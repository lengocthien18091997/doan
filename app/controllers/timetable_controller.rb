class TimetableController < ApplicationController

  def list
    if @current_user.role == 'student'
      @timetable = Timetable.joins("JOIN users ON users.id = timetables.teacher_id")
                      .joins("LEFT JOIN tuitions ON tuitions.timetables_id = timetables.id")
                     .where(status: ['deposit'], student_id: @current_user.id)
                     .select("timetables.*, users.full_name AS full_name, tuitions.status AS tuitions_status")
    else
      @timetable = Timetable.joins("JOIN users ON users.id = timetables.teacher_id")
          .joins("LEFT JOIN tuitions ON tuitions.timetables_id = timetables.id")
          .where(status: %w(deposit), teacher_id: @current_user.id)
          .select("timetables.*, users.full_name AS full_name, tuitions.status AS tuitions_status")
    end
    # @timetable = @timetable.paginate(page: params[:page], per_page: Constant::LIMIT_PER_PAGE)
  end

  def done
    timetable = Timetable.find(params[:id])
    timetable.update!(status: "closed")
    Request.find(timetable.request_id).update(status: "closed")
    redirect_back fallback_location: root_path, notice: "Đã xác nhận học xong"
  end
end
