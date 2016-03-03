# encoding: utf-8
#
# @author Vivian <tchu@ucsd.edu>
#
class AnalyticsController < ApplicationController
  include Dmr::SplunkApiHelper
  before_action :authorize

  def index
    return unless params[:start_date] && params[:end_date]
    s_date = time_convert(params[:start_date], '12:00AM')
    e_date = time_convert(params[:end_date], '11:59PM')
    @course_count = new_course_count(s_date, e_date) + clone_course_count(s_date, e_date)
    @record_count = new_record_count(s_date, e_date)
    @view_counter = view_count(s_date, e_date)
  end
end
