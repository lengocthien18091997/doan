class RequestController < ApplicationController
  before_action :set_teacher, only: [:new, :create]

  def new
    # set_teacher
  end

  def create
    # set_teacher
    old_request = Request.where(student_id: current_user)
    # binding.pry
    if params[:teacher_full_name].blank? || params[:mon_cap].blank? || params[:date_time].blank? || params[:location].blank? || params[:budget].blank?
      flash.now[:alert] = "Vui lòng nhập đầy đủ thông tin!"
      render :new, status: :unprocessable_entity
      return
    end
    subject = params[:mon_cap].split(' - ').first.gsub('_', ' ')
    grade_level = params[:mon_cap].split(' - ').last
    if old_request.where(subject: subject).present?
      flash[:alert] = "Đã gửi lời mời cho môn này rồi!"
      render :new, status: :unprocessable_entity
      return
    end

    old_lich_hoc = []
    old_lich_hoc = old_request.pluck(:schedule).map { |date, time| ["#{date} - #{time}"] } if old_request.present?
    if old_lich_hoc.present? && old_lich_hoc.include?(params[:date_time])
      flash[:alert] = "Đã gửi lời mời cho thời gian này rồi!"
      render :new, status: :unprocessable_entity
      return
    end
    date_time = params[:date_time].split(' - ')
    date_time = { date_time.first.gsub('_', ' ') => date_time.last.gsub('_', ' ') }
    flash[:notice] = "Đăng kí thành công!"
    Request.create!(
      student_id: @current_user.id,
      teacher_id: @teacher.id,
      subject: subject,
      grade_level: grade_level,
      requirement_detail: params[:req_detail],
      budget: params[:budget],
      location: params[:location],
      schedule: date_time,
      status: 'open'
    )
    redirect_to request_list_path
  end

  # def list
  #   if @current_user.role == 'student'
  #     @request = Request.joins("JOIN users ON users.id = requests.teacher_id")
  #                    .where(student_id: @current_user.id)
  #                    .select("requests.*, users.full_name AS full_name")
  #   else
  #     @request = Request.joins("JOIN users ON users.id = requests.teacher_id")
  #                    .where(teacher_id: @current_user.id)
  #                    .select("requests.*, users.full_name AS full_name")
  #   end
  #   @request = @request.paginate(page: params[:page], per_page: 3)
  # end

  def list
    base_query = Request
                     .joins("JOIN users ON users.id = requests.teacher_id")
                     .includes(:tuition)
                     .select("requests.*, users.full_name AS teacher_name")

    @request =
        if @current_user.role == 'student'
          base_query.where(student_id: @current_user.id)
        else
          base_query.where(teacher_id: @current_user.id)
        end

    @request = @request.paginate(page: params[:page], per_page: 3)
  end


  def accep
    req = Request.find(params[:id])
    req.update!(status: "accepted")

    time = Timetable.create!(
        teacher_id: req.teacher_id,
        student_id: req.student_id,
        subject: req.subject,
        schedule: req.schedule,
        status: "open",
        location: req.location,
        request_id: req.id
    )

    Tuition.create!(
        teacher_id: req.teacher_id,
        student_id: req.student_id,
        timetables_id: time.id,
        amount: req.budget,
        status: "new",
        request_id: req.id
    )
    redirect_to root_path
  end

  def denial
    Request.where(id: params[:id]).update_all(status: 'rejected')
    redirect_to root_path
  end

  private

  def set_teacher
    @teacher = User.find(params[:id])
  end

end
