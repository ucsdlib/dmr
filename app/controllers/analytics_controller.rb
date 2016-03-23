# encoding: utf-8
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
    @item_count = new_item_count(s_date, e_date)
    @course_count = new_course_count(s_date, e_date) + clone_course_count(s_date, e_date)
    @record_count = new_record_count(s_date, e_date)
    @view_counter = view_count(s_date, e_date)
  end
end
