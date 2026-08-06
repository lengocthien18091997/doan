class SupportController < ApplicationController

  def list
    @support = Support.all.order(:id)
    @support = @support.paginate(page: params[:page], per_page: Constant::LIMIT_PER_PAGE)
  end

  def create
    if params[:support][:category].blank? || params[:support][:comment].blank?
      flash.now[:alert] = "Nhập đầy đủ thông tin nhé!"
      render :list, status: :unprocessable_entity
      return
    end
    Support.create!(
        user_id: @current_user.id,
        category: params[:support][:category],
        comment: params[:support][:comment],
        status: Constant::SUPPORT_STATUS_OPEN
    )
    flash[:notice] = "Gửi thành công!"
    redirect_to support_path
  end

  def processing
    @support = Support.find(params[:id])
    @support.update(status: Constant::SUPPORT_STATUS_PROCESSING)
    redirect_to support_path, notice: "Đã đánh dấu đang xử lý!"
  end

  def closed
    @support = Support.find(params[:id])
    @support.update(status: Constant::SUPPORT_STATUS_CLOSED)
    redirect_to support_path, notice: "Đã đánh dấu đã xử lý!"
  end
end

