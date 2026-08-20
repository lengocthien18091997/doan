require "fileutils"
require "securerandom"
require "tempfile"
require "zip"

class UserController < ApplicationController

  skip_before_action :authorization, only: [:new, :create]
  # GET /index
  def new
  end

  def create
    if params[:new_email].blank? || params[:new_password].blank? || params[:re_password].blank? || params[:role].blank?
      flash.now[:alert] = "Vui lòng nhập đầy đủ thông tin!"
      render :new, status: :unprocessable_entity
    elsif User.find_by(email: params[:new_email]).present?
      flash[:notice] = "Email đã tồn tại!"
      render :new, status: :unprocessable_entity
    elsif params[:new_password] != params[:re_password]
      flash.now[:alert] = "Nhập mật khẩu không trùng lặp!"
      render :new, status: :unprocessable_entity
    else
      flash[:notice] = "Đăng kí thành công!"
      User.create!(full_name: '..chưa có tên..', email: params[:new_email], password: params[:new_password], role: params[:role])
      redirect_to register_path
    end
  end

  def get
    @current_user.build_teacher_profile if @current_user.teacher_profile.nil?
    render :update
  end

  def registration_form
    redirect_to user_update_path and return unless @current_user.role == "teacher"

    @current_user.build_teacher_profile if @current_user.teacher_profile.nil?
    @registration_form = teacher_registration_export(@current_user)
  end

  def contract_form
    redirect_to root_path and return unless @current_user.role == "admin"

    @teacher = User.find(params[:id])
    redirect_to root_path and return unless @teacher.role == "teacher"

    @teacher.build_teacher_profile if @teacher.teacher_profile.nil?
    @contract_form = teacher_contract_export(@teacher)
  end

  def update
    update_params = params_update
    documents = Array(update_params.dig(:teacher_profile_attributes, :document)).reject(&:blank?)
    update_params[:teacher_profile_attributes].delete(:document) if update_params[:teacher_profile_attributes]

    if documents.present? && !valid_teacher_documents?(documents)
      flash.now[:alert] = "Có thể gửi tối đa 4 file .png hoặc .jpg, mỗi file không vượt quá 10 MB."
      return render :update, status: :unprocessable_entity
    end

    if update_params[:password].blank?
      update_params.delete(:password)
    end

    if @current_user.update(update_params)
      save_teacher_documents(documents) if documents.present?
      flash[:notice] = "Cập nhật thành công!"
      redirect_to user_update_path
    else
      flash.now[:alert] = "Cập nhật thất bại, vui lòng kiểm tra lại."
      render :edit, status: :unprocessable_entity
    end
  end

  def lock
    update = User.find(params[:id]).update(is_locked: true)
    if update
      flash[:notice] = "Cập nhật thành công!"
      redirect_to root_path
    else
      flash.now[:alert] = "Cập nhật thất bại, vui lòng kiểm tra lại."
      render :edit, status: :unprocessable_entity
    end
  end

  def unlock
    update = User.find(params[:id]).update(is_locked: false)
    if update
      flash[:notice] = "Cập nhật thành công!"
      redirect_to root_path
    else
      flash.now[:alert] = "Cập nhật thất bại, vui lòng kiểm tra lại."
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_contract
    redirect_to root_path and return unless @current_user.role == "admin"

    teacher = User.find(params[:id])
    redirect_to root_path and return unless teacher.role == "teacher"

    if teacher.update(contract_confirmed: true)
      flash[:notice] = "Xác nhận hợp đồng thành công!"
    else
      flash[:alert] = "Xác nhận hợp đồng thất bại."
    end

    redirect_to root_path
  end

  def detail
    @user_detail = User.find(params[:id])
  end

  def download_teacher_document
    redirect_to root_path and return unless @current_user.role == "admin"

    teacher = User.find(params[:id])
    profile = teacher.teacher_profile
    documents = stored_documents(profile)
    redirect_to root_path, alert: "Gia sư chưa gửi hồ sơ." and return unless teacher.role == "teacher" && documents.present?

    files = documents.filter_map do |document|
      file_path = Rails.root.join("storage", document["path"])
      [document["filename"].to_s, file_path] if File.file?(file_path)
    end
    redirect_to root_path, alert: "Không tìm thấy hồ sơ." and return if files.empty?

    zip_file = Tempfile.new(["teacher-documents", ".zip"])
    zip_file.close
    Zip::File.open(zip_file.path, create: true) do |zip|
      files.each_with_index do |(filename, file_path), index|
        zip.add("#{index + 1}-#{File.basename(filename)}", file_path.to_s)
      end
    end

    send_data File.binread(zip_file.path), filename: "ho-so-gia-su-#{teacher.id}.zip", type: "application/zip", disposition: "attachment"
  ensure
    zip_file&.unlink
  end

  private

  def valid_teacher_documents?(documents)
    existing_count = stored_documents(@current_user.teacher_profile).length
    documents.length + existing_count <= 4 && documents.all? do |document|
      [".png", ".jpg"].include?(File.extname(document.original_filename).downcase) && document.size <= 10.megabytes
    end
  end

  def save_teacher_documents(documents)
    return unless @current_user.role == "teacher"

    profile = @current_user.teacher_profile || @current_user.create_teacher_profile
    storage_directory = Rails.root.join("storage", "teacher_documents")
    FileUtils.mkdir_p(storage_directory)

    new_documents = documents.map do |document|
      extension = File.extname(document.original_filename).downcase
      filename = "#{SecureRandom.uuid}#{extension}"
      File.binwrite(storage_directory.join(filename), document.read)
      { "path" => File.join("teacher_documents", filename), "filename" => document.original_filename }
    end

    profile.update!(documents: stored_documents(profile) + new_documents)
  end

  def stored_documents(profile)
    return [] unless profile

    documents = profile.documents.presence
    return documents if documents.present?
    return [] if profile.document_path.blank?

    [{ "path" => profile.document_path, "filename" => profile.document_filename }]
  end
end



