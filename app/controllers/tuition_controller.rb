class TuitionController < ApplicationController

  def index
    # dk = current_user.role == 'teacher' ? "teacher_id = #{current_user.id}" : "student_id = #{current_user.id}"
    # @tuitions = Tuition
    #                 .joins(:teacher, :student)
    # .select("tuitions.*, teachers.full_name AS teacher_name, students.full_name AS student_name, timetables.subject, timetables.schedule")
    #                 .joins("JOIN users teachers ON teachers.id = tuitions.teacher_id")
    #                 .joins("JOIN users students ON students.id = tuitions.student_id")
    #                 .joins('JOIN timetables ON timetables.id = tuitions.timetables_id')
    #     .where(dk).order(:id)

    dk = if current_user.role == Constant::ROLE_TEACHER
           ["tuitions.teacher_id = ?", current_user.id]
         elsif current_user.role == Constant::ROLE_STUDENT
           ["tuitions.student_id = ?", current_user.id]
         else
           []
         end

    @tuitions = Tuition
                    .joins("JOIN users teachers ON teachers.id = tuitions.teacher_id")
                    .joins("JOIN users students ON students.id = tuitions.student_id")
                    .joins("JOIN timetables ON timetables.id = tuitions.timetables_id")
                    .select("tuitions.*, teachers.full_name AS teacher_name, students.full_name AS student_name, timetables.subject, timetables.schedule")
                    .where(dk)
                    .order(:id)
    @tuitions = @tuitions.paginate(page: params[:page], per_page: Constant::LIMIT_PER_PAGE)
  end

  def pay
    @tuition = Tuition.find(params[:id])

    @teacher = @tuition.teacher
    @profile = @teacher.teacher_profile

    @qr_url = vietqr_url(
        bank_code: @profile.bank_code,      # ví dụ: "VCB"
        account_no: @profile.bank_account_number,  # số tài khoản
        account_name: @profile.bank_account_name,  # tên chủ TK
        amount: @tuition.amount/2,
        desc: "Hoc phi #{ @tuition.student.full_name }"
    )
  end

  def invoice
    @tuition = Tuition.find(params[:id])
    redirect_to root_path and return unless current_user.role == Constant::ROLE_STUDENT || current_user.role == Constant::ROLE_ADMIN

    @tuition_export = tuition_invoice_export(@tuition)
  end

  def deposit
    @tuition = Tuition.find(params[:id])
    @tuition.update(status: Constant::TUITION_STATUS_DEPOSIT, timetables_id: @tuition.timetables_id)
    Timetable.where(id: @tuition.timetables_id).update_all(status: Constant::TIMETABLE_STATUS_DEPOSIT)
    redirect_to tuition_path, notice: "Đã xác nhận cọc"
  end

  def complete
    @tuition = Tuition.find(params[:id])
    @tuition.update(status: Constant::TUITION_STATUS_PAYED)
    redirect_to tuition_path, notice: "Đã hoàn thành học phí"
  end
end

