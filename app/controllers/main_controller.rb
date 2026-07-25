require 'csv'

class MainController < ApplicationController
  skip_before_action :authorization, only: [:index]

  # GET /index
  def index
    @user = User.all
    @user = @user.left_joins(teacher_requests: :review).select('users.*', 'AVG(reviews.star) AS star').group('users.id')
    unless current_user
      @user = @user.where(role: 'teacher', contract_confirmed: true)
      search_user
      @user = @user.order(Arel.sql('COALESCE(AVG(reviews.star), 0) DESC')).paginate(page: params[:page], per_page: Constant::LIMIT_PER_PAGE)
      return
    end

    @current_user.reload
    if @current_user.role == 'student'
      @user = @user.where(role: 'teacher', contract_confirmed: true)
    end
    search_user
    @user = @user.order(Arel.sql('COALESCE(AVG(reviews.star), 0) DESC')).paginate(page: params[:page], per_page: Constant::LIMIT_PER_PAGE)
    @request = Request.joins("JOIN users ON users.id = requests.student_id")
                   .where(teacher_id: @current_user.id)
                   .select("requests.*, users.full_name AS full_name")

    # 🔍 Lọc theo trạng thái
    if params[:status].present?
      @request = @request.where(status: params[:status])
    end

    # 🔍 Lọc theo địa điểm
    if params[:location].present?
      @request = @request.where("requests.location ILIKE ?", "%#{params[:location]}%")
    end

    # 🔍 Lọc theo học phí
    if params[:budget_min].present?
      @request = @request.where("requests.budget >= ?", params[:budget_min])
    end

    if params[:budget_max].present?
      @request = @request.where("requests.budget <= ?", params[:budget_max])
    end

    # 🔍 Lọc theo Môn - Cấp học
    if params[:mon_cap].present?
      subject, level = params[:mon_cap].split(" - ")
      @request = @request.where(subject: subject, grade_level: level)
    end
    @request = @request.order(Arel.sql("CASE WHEN requests.status = 'open' THEN 0 ELSE 1 END, requests.id DESC"))

    @request = @request.paginate(page: params[:page], per_page: Constant::LIMIT_PER_PAGE)
  end

  def dashboard
    @today = Time.zone.today
    @week_days = ["Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ nhật"]
    @session_blocks = ["Buổi sáng", "Buổi chiều", "Buổi tối"]
    @current_user.reload

    case @current_user.role
    when 'student'
      @dashboard = student_dashboard
    when 'teacher'
      @dashboard = teacher_dashboard
    when 'admin'
      @dashboard = admin_dashboard
    else
      redirect_to login_path
    end
  end

  def export_users
    redirect_to root_path and return unless @current_user.role == 'admin'

    @user = User.all
    @user = @user.left_joins(teacher_requests: :review).select('users.*', 'AVG(reviews.star) AS star').group('users.id')
    search_user
    @user = @user.order(Arel.sql('COALESCE(AVG(reviews.star), 0) DESC'))
    now = Time.zone.today
    @export_date = "Hà Nội, Ngày #{now.day}, tháng #{now.month}, năm #{now.year}"
  end

  def new_user_import
    redirect_to root_path and return unless @current_user.role == 'admin'
  end

  def import_users
    redirect_to root_path and return unless @current_user.role == 'admin'

    if params[:csv_file].blank?
      flash[:alert] = "Vui lòng chọn tệp CSV."
      redirect_to user_import_path and return
    end

    imported = 0
    errors = []
    csv_text = params[:csv_file].read
    csv = CSV.parse(csv_text, headers: true)

    csv.each_with_index do |row, index|
      attrs = row.to_hash.transform_keys { |key| key.to_s.strip.downcase }
      user = User.new(
        full_name: attrs['full_name'],
        email: attrs['email'],
        password: attrs['password'],
        is_locked: parse_boolean(attrs['is_lock']),
        phone_number: attrs['phone_number'],
        role: attrs['role'],
        gender: attrs['gender'],
        date_of_birth: parse_date(attrs['date_of_birth']),
        contract_confirmed: parse_boolean(attrs['contract_confirmed'])
      )

      if user.save
        imported += 1
      else
        errors << "Dòng #{index + 2}: #{user.errors.full_messages.join(', ')}"
      end
    end

    notice_message = "Đã nhập thành công #{imported} user."
    notice_message += " Một số dòng không hợp lệ: #{errors.join(' | ')}" if errors.any?
    flash[:notice] = notice_message
    redirect_to root_path
  end

  def search_user
    unless current_user
      @user = @user.left_joins(:teacher_profile)
      if params[:query].present?
        q = "%#{params[:query]}%"
        @user = @user.where("full_name LIKE ? OR email LIKE ?", q, q)
      end
      if params[:location].present?
        @user = @user.where("teacher_profiles.location::text ILIKE ?", "%#{params[:location]}%")
      end
      if params[:mon_hoc].present? && params[:cap_hoc].present?
        @user = @user.where("teacher_profiles.subjects ->> :key = :value",
                           key: params[:mon_hoc],
                           value: params[:cap_hoc])
      elsif params[:mon_hoc].present?
        @user = @user.where("teacher_profiles.subjects ? :key", key: params[:mon_hoc])
      elsif params[:cap_hoc].present?
        @user = @user.where("teacher_profiles.subjects::text ILIKE ?", "%#{params[:cap_hoc]}%")
      end
      return
    end

    if params[:commit].nil?
      if @current_user.role == 'student'
        cap_hoc = tinh_cap_hoc(@current_user.date_of_birth)
        @user = @user.left_joins(:teacher_profile)
                    .where("teacher_profiles.subjects::text ILIKE ?", "%#{cap_hoc}%")
      else
        @user = @user.left_joins(:teacher_profile)
      end
      return
    end
    if params[:query].present?
      q = "%#{params[:query]}%"
      @user = @user.where("full_name LIKE ? OR email LIKE ?", q, q)
    end
    if params[:location].present?
      q = "%#{params[:location]}%"
      @user = @user.joins(:teacher_profile)
                  .where("teacher_profiles.location::text ILIKE ?", "%#{q}%")
    end
    if params[:mon_hoc].present? && params[:cap_hoc].present?
      @user = @user.joins(:teacher_profile)
                  .where("teacher_profiles.subjects ->> :key = :value",
                         key: params[:mon_hoc],
                         value: params[:cap_hoc])
    elsif params[:mon_hoc].present?
      @user = @user.joins(:teacher_profile)
                  .where("teacher_profiles.subjects ? :key", key: params[:mon_hoc])
    elsif params[:cap_hoc].present?
      @user = @user.joins(:teacher_profile)
                  .where("teacher_profiles.subjects::text ILIKE ?", "%#{params[:cap_hoc]}%")
    end
    if params[:role].present?
      @user = @user.where(role: params[:role])
    end
  end

  private

  def parse_boolean(value)
    return false if value.blank?
    value = value.to_s.strip.downcase
    %w[1 true yes y x].include?(value)
  end

  def parse_date(value)
    return nil if value.blank?
    return value if value.is_a?(Date)

    Date.parse(value.to_s)
  rescue ArgumentError
    nil
  end

  def student_dashboard
    accepted_requests = Timetable.includes(:teacher).where(student_id: @current_user.id).where(status: %w(deposit open))
    open_requests = Timetable.includes(:teacher).where(student_id: @current_user.id).where(status: 'closed').order(:id)
    unpaid_tuitions = @current_user.student_tuitions.where(status: 'new')
    outstanding_tuitions = @current_user.student_tuitions.where(status: %w(new deposit)).includes(:teacher)
    pending_reviews = Request.joins(:teacher).left_joins(:review).where(student_id: current_user.id).where(review: { id: nil })
    timetable_entries = Timetable.includes(:teacher).where(student_id: @current_user.id).where(status: %w(deposit open)).order(:id)
    top_teachers = User.left_joins(teacher_requests: :review)
                        .where(role: 'teacher', contract_confirmed: true)
                        .select('users.*', 'COALESCE(AVG(reviews.star), 0) AS avg_star')
                        .group('users.id')
                        .order(Arel.sql('COALESCE(AVG(reviews.star), 0) DESC'))
                        .limit(5)

    {
      accepted_count: accepted_requests.count,
      open_count: open_requests.count,
      unpaid_tuition_count: unpaid_tuitions.count,
      pending_review_count: pending_reviews.count,
      timetable_entries: timetable_entries,
      outstanding_tuitions: outstanding_tuitions,
      top_teachers: top_teachers
    }
  end

  def teacher_dashboard
    open_requests = @current_user.teacher_requests.where(status: 'open').includes(:student)
    accepted_requests = Timetable.includes(:teacher).where(teacher_id: @current_user.id).where(status: %w(deposit))
    accepted_requests_coc = Timetable.includes(:teacher).where(teacher_id: @current_user.id).where(status: %w(open))
    waiting_tuition = @current_user.teacher_tuitions.where(status: ['deposit', 'new'])
    average_rating = Review.joins(:request).where(requests: { teacher_id: @current_user.id }).average(:star).to_f.round(1)
    last_months = last_six_months
    monthly_income = last_months.map do |date|
      total = @current_user.teacher_tuitions
                           .left_joins(:request)
                           .where(status: 'payed')
                           .where(requests: { created_at: date.beginning_of_month..date.end_of_month })
                           .sum(:amount)
      { label: date.strftime('%b'), total: total }
    end
    weekly_schedule = Timetable.includes(:student).where(teacher_id: @current_user.id).where(status: 'deposit').order(:id)

    {
      open_count: open_requests.count,
      accepted_count: accepted_requests.count,
      accepted_count_coc: accepted_requests_coc.count,
      waiting_tuition_count: waiting_tuition.count,
      waiting_tuition_amount: waiting_tuition.sum(:amount),
      average_rating: average_rating.zero? ? 0 : average_rating,
      open_requests: open_requests,
      monthly_income: monthly_income,
      current_month_income: monthly_income.last[:total],
      weekly_schedule: weekly_schedule
    }
  end

  def admin_dashboard
    teacher_count = User.where(role: 'teacher').count
    student_count = User.where(role: 'student').count
    pending_teachers = User.where(role: 'teacher', contract_confirmed: false)
    locked_users = User.where(is_locked: true)
    last_months = last_six_months
    monthly_courses = last_months.map do |date|
      open_count = Request.where(status: 'open').where(created_at: date.beginning_of_month..date.end_of_month).count
      closed_count = Request.where(status: 'closed').where(created_at: date.beginning_of_month..date.end_of_month).count
      { label: date.strftime('%b'), open_count: open_count, closed_count: closed_count }
    end

    {
      teacher_count: teacher_count,
      student_count: student_count,
      pending_contracts_count: pending_teachers.count,
      locked_accounts_count: locked_users.count,
      active_courses_count: Timetable.where(status: %w(deposit open)).count,
      pending_teachers: pending_teachers,
      user_distribution: {
        teacher: teacher_count,
        student: student_count,
        admin: User.where(role: 'admin').count
      },
      monthly_courses: monthly_courses,
      recent_locked: locked_users.order(updated_at: :desc).limit(5)
    }
  end

  def last_six_months
    (5.downto(0)).map { |i| @today.prev_month(i) }
  end
end


