#
# @author Vivian <tchu@ucsd.edu>
#
class LicensedAnalyticsController < ApplicationController
  include Dmr::SplunkApiHelper
  before_action :authorize

  def index
    return unless params[:start_date] && params[:end_date]
    s_date = convert_time(params[:start_date], '00:00:00-8')
    e_date = convert_time(params[:end_date], '23:59:59-8')
    if params[:type]
      @new_audio_count = licensed_audio_count(s_date, e_date)
      @audio_view_counter = licensed_audio_view(s_date, e_date)
    else
      @record_count = licensed_video_count(s_date, e_date)
      @view_counter = licensed_video_view(s_date, e_date)
    end
  end
end
