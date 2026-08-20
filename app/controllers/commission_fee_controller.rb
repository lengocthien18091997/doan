class CommissionFeeController < ApplicationController
  def index
    redirect_to root_path and return unless [Constant::ROLE_TEACHER, Constant::ROLE_ADMIN].include?(current_user.role)

    @commission_fees = if current_user.role == Constant::ROLE_TEACHER
                         CommissionFee.includes(:student, :timetable).where(teacher_id: current_user.id)
                       elsif current_user.role == Constant::ROLE_ADMIN
                         CommissionFee.includes(:teacher, :timetable).all
                       else
                         CommissionFee.none
                       end
    @commission_fees = @commission_fees.order(:id).paginate(page: params[:page], per_page: Constant::LIMIT_PER_PAGE)
  end

  def pay
    @commission_fee = CommissionFee.includes(:student, :timetable).find(params[:id])
    redirect_to commission_fee_path, alert: "Bạn không có quyền nộp khoản phí này." and return unless teacher_owner?
    redirect_to commission_fee_path, alert: "Khoản phí này không còn ở trạng thái cần nộp." and return unless @commission_fee.status == Constant::COMMISSION_FEE_STATUS_NEW

    @center_bank = center_bank_config
    @transfer_desc = "Phi hoa hong lop #{@commission_fee.timetable_id} #{@commission_fee.teacher.full_name}"
    @qr_url = vietqr_url(
      bank_code: @center_bank[:bank_code],
      account_no: @center_bank[:account_no],
      account_name: @center_bank[:account_name],
      amount: @commission_fee.amount,
      desc: @transfer_desc
    )
  end

  def submit_transfer
    commission_fee = CommissionFee.find(params[:id])
    unless commission_fee.teacher_id == current_user.id && commission_fee.status == Constant::COMMISSION_FEE_STATUS_NEW
      redirect_to commission_fee_path, alert: "Bạn không thể cập nhật khoản phí này." and return
    end

    commission_fee.update!(status: Constant::COMMISSION_FEE_STATUS_PENDING_ADMIN)
    redirect_to commission_fee_path, notice: "Đã ghi nhận chuyển khoản phí hoa hồng, vui lòng chờ admin xác nhận."
  end

  def confirm_received
    redirect_to commission_fee_path and return unless current_user.role == Constant::ROLE_ADMIN

    commission_fee = CommissionFee.find(params[:id])
    unless commission_fee.status == Constant::COMMISSION_FEE_STATUS_PENDING_ADMIN
      redirect_to commission_fee_path, alert: "Khoản phí này không ở trạng thái chờ xác nhận." and return
    end

    commission_fee.update!(status: Constant::COMMISSION_FEE_STATUS_DONE)
    redirect_to commission_fee_path, notice: "Đã xác nhận nhận phí hoa hồng."
  end

  private

  def teacher_owner?
    current_user.role == Constant::ROLE_TEACHER && @commission_fee.teacher_id == current_user.id
  end

  def center_bank_config
    Rails.configuration.x.center_bank
  end
end