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
      @new_audio_count = new_audio_record_count(s_date, e_date)
      @audio_view_counter = audio_view_count(s_date, e_date)
    else
      @record_count = new_record_count(s_date, e_date)
      @view_counter = view_count(s_date, e_date)
      @item_count = new_item_count(s_date, e_date) - @audio_count
      @total_course = new_course_count(s_date, e_date) + clone_course_count(s_date, e_date)
      @course_count = @total_course - @audio_course_count if @total_course > 0
    end
  end
end
