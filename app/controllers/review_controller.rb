class ReviewController < ApplicationController

  def list
    @role = current_user.role == "teacher" ? 0 : 1

    if @role.zero?
      # Teacher → xem review của student
      @requests = Request
                      .joins(:student)
                      .left_joins(:review)
                      .where(teacher_id: current_user.id)
                      .select(
                          "requests.*,
       users.full_name AS user_full_name,
       reviews.id AS review_id,
       reviews.star,
       reviews.comment"
                      )
    else
      # Student → xem review của teacher
      @requests = Request.joins(:teacher).left_joins(:review).where(student_id: current_user.id).select(
                          "requests.*,
       users.full_name AS user_full_name,
       reviews.id AS review_id,
       reviews.star,
       reviews.comment"
                      )
    end

  end

  def create
    request = Request.find(params[:review][:request_id])

    # Chặn tạo trùng review
    if request.review.present?
      redirect_back fallback_location: root_path,
                    alert: "Request này đã được review"
      return
    end

    review = Review.new(review_params)
    review.request = request

    # Gán role theo người đang login
    review.role = 1
        # current_user.role == "teacher" ? :teacher : :student

    if review.save
      redirect_back fallback_location: root_path,
                    notice: "Đã gửi review thành công"
    else
      redirect_back fallback_location: root_path,
                    alert: "System error"
    end
  end

  private

  def review_params
    params.require(:review).permit(:star, :comment)
  end
end