# encoding: utf-8
#
# @author Vivian <tchu@ucsd.edu>
#

require 'splunk-sdk-ruby'
require 'date'
require 'time_diff'

module Dmr
  #
  # Collection of methods to support the Analytics Controller
  #
  module SplunkApiHelper
    WOWZAHOST = Rails.configuration.wowza_baseurl.split(':')[0]
    S_HOST = Rails.configuration.splunk_host
    TOTAL = '| stats count as Total'

    def stats(query, start_date, end_date)
      service = Splunk.connect(host: Rails.application.secrets.splunk_uri,
                           username: Rails.application.secrets.splunk_username,
                           password: Rails.application.secrets.splunk_password)
      job = service.create_search(query, earliest_time: start_date, latest_time: end_date)
      sleep(0.1) until job.is_ready?
      sleep(0.1) until job.is_done?

      stream = job.results(offset: 0)
      Splunk::ResultsReader.new(stream)
    end

    def data_count(query, s_date, e_date)
      count = 0
      data = stats(query, s_date, e_date)
      data.each do |result|
        count = result['Total']
      end
      count.to_i
    end

    def new_course_count(s_date, e_date)
      q = "search sourcetype=access_common host=#{S_HOST} edu/dmr/courses/new 200 #{TOTAL}"
      data_count(q, s_date, e_date)
    end

    def clone_course_count(s_date, e_date)
      q = "search sourcetype=access_common host=#{S_HOST} dmr/courses/clone 302 #{TOTAL}"
      data_count(q, s_date, e_date)
    end

    def new_record_count(s_date, e_date)
      q = "search sourcetype=access_common host=#{S_HOST} edu/dmr/media/new 200 #{TOTAL}"
      data_count(q, s_date, e_date)
    end

    def view_count(s_date, e_date)
      stop_time = stop_time_view(s_date, e_date)
      q = "search sourcetype=wowza_access host=#{WOWZAHOST} play stream 200 dmr"
      data = stats(q, s_date, e_date)
      process_count(data, stop_time)
    end

    def process_count(data, stop_time)
      v_count = 0
      data.each do |result|
        tmp = result['_raw'].to_s.split
        filename = tmp[7]

        if stop_time.key?("#{filename}-#{tmp[21]}")
          time_min_diff = Time.diff(tmp[1], stop_time["#{filename}-#{tmp[21]}"])[:minute]
          v_count += 1 if time_min_diff >= 5
        end
      end
      v_count
    end

    def stop_time_view(s_date, e_date)
      q = "search sourcetype=wowza_access host=#{WOWZAHOST} stop stream 200 dmr"
      data = stats(q, s_date, e_date)
      files = {}
      data.each do |result|
        tmp_result = result['_raw'].to_s.split
        files["#{tmp_result[7]}-#{tmp_result[21]}"] = tmp_result[1]
      end
      files
    end

    def time_convert(date, time)
      if DateTime.current.strftime('%m/%d/%Y').include?(date) && time.include?('PM')
        d_time = 'now'
      else
        d_time = DateTime.strptime("#{date} #{time}", '%m/%d/%Y %H:%M%p')
      end
      d_time
    end
  end
end
