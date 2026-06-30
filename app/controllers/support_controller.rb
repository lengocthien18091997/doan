class SupportController < ApplicationController

  def list
    @support = Support.all.order(:id)
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
        status: 'open'
    )
    flash[:notice] = "Gửi thành công!"
    redirect_to support_path
  end

  def processing
    @support = Support.find(params[:id])
    @support.update(status: "processing")
    redirect_to support_path, notice: "Đã đánh dấu đang xử lý!"
  end

  def closed
    @support = Support.find(params[:id])
    @support.update(status: "closed")
    redirect_to support_path, notice: "Đã đánh dấu đã xử lý!"
  end
end

