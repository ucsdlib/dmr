#
# @author Vivian <tchu@ucsd.edu>
#
class AnalyticsController < ApplicationController
  include Dmr::SplunkApiHelper
  before_action :authorize

  def index
    return unless params[:start_date] && params[:end_date]
    s_date = convert_time(params[:start_date], '00:00:00-8')
    e_date = convert_time(params[:end_date], '23:59:59-8')
    @audio_count = new_audio_count(s_date, e_date)
    @audio_course_count = audio_course_count(s_date, e_date)
    if params[:type]
      total_audio_view = audio_view_count(s_date, e_date)
      total_audio_new = new_audio_record_count(s_date, e_date)
      @new_audio_count = total_audio_new - licensed_audio_count(s_date, e_date) if total_audio_new.positive?
      @audio_view_counter = total_audio_view - licensed_audio_view(s_date, e_date) if total_audio_view.positive?
    else
      total_view = view_count(s_date, e_date)
      total_new = new_record_count(s_date, e_date)
      @record_count = total_new - licensed_video_count(s_date, e_date) if total_new.positive?
      @view_counter = total_view - licensed_video_view(s_date, e_date) if total_view.positive?
      @item_count = new_item_count(s_date, e_date) - @audio_count
      @total_course = new_course_count(s_date, e_date) + clone_course_count(s_date, e_date)
      @course_count = @total_course - @audio_course_count if @total_course.positive?
    end
  end
end
