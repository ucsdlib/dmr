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
    RAILS_HOST = Rails.configuration.rails_host
    TOTAL = '| stats count as Total'
    AUDIO_MIN_PLAYTIME = 22_000

    def stats(query, start_date, end_date)
      service = Splunk.connect(host: Rails.application.secrets.splunk_uri,
                           username: Rails.application.secrets.splunk_username,
                           password: Rails.application.secrets.splunk_password)
      job = service.create_oneshot(query, earliest_time: start_date, latest_time: end_date,
                                   count: 100_000, offset: 0)
      Splunk::ResultsReader.new(job)
    end

    def data_count(query, s_date, e_date)
      count = 0
      data = stats(query, s_date, e_date)
      data.each do |result|
        count = result['Total']
      end
      count.to_i
    end

    def new_item_count(s_date, e_date)
      q = "search sourcetype=rails host=#{RAILS_HOST} CoursesController#add_to_course media_ids"
      data = stats(q, s_date, e_date)
      id_count = 0
      data.each do |result|
        tmp = result['_raw'].delete('"').delete(' ')
        tmp_result = tmp.split(/media_ids=>\[/)[1]
        id_count += tmp_result.split(/\]/).first.split(',').length
      end
      id_count
    end

    def new_audio_count(s_date, e_date)
      q = "search sourcetype=rails host=#{RAILS_HOST} CoursesController#add_to_course media_ids"
      q += ' "type"=>"audio"'
      data = stats(q, s_date, e_date)
      id_count = 0
      data.each do |result|
        tmp = result['_raw'].delete('"').delete(' ')
        tmp_result = tmp.split(/media_ids=>\[/)[1]
        id_count += tmp_result.split(/\]/).first.split(',').length
      end
      id_count
    end

    def new_course_count(s_date, e_date)
      q = "search sourcetype=access_common host=#{S_HOST} edu/dmr/courses/new 200 #{TOTAL}"
      data_count(q, s_date, e_date)
    end

    def audio_course_count(s_date, e_date)
      q = "search sourcetype=rails host=#{RAILS_HOST} CoursesController#add_to_course media_ids"
      q += ' "type"=>"audio"'
      data = stats(q, s_date, e_date)
      course_array = []
      data.each do |result|
        tmp = result['_raw'].delete('"').delete(' ')
        tmp_course_id = tmp.split(/course_id,/)[1].split(/\]/)[0] if tmp.include?('course_id,')
        course_array << tmp_course_id if !course_array.include?(tmp_course_id)
      end
      course_array.length
    end

    def clone_course_count(s_date, e_date)
      q = "search sourcetype=access_common host=#{S_HOST} dmr/courses/clone 302 #{TOTAL}"
      data_count(q, s_date, e_date)
    end

    def new_record_count(s_date, e_date)
      q = "search sourcetype=access_common host=#{S_HOST} edu/dmr/media/new 200 #{TOTAL}"
      data_count(q, s_date, e_date)
    end

    def new_audio_record_count(s_date, e_date)
      q = "search sourcetype=access_common host=#{S_HOST} edu/dmr/audios/new 200 #{TOTAL}"
      data_count(q, s_date, e_date)
    end

    def view_count(s_date, e_date)
      stop_time = stop_time_view(s_date, e_date)
      q = "search sourcetype=wowza_access host=#{WOWZAHOST} play stream 200 dmr mp4"
      data = stats(q, s_date, e_date)
      process_count(data, stop_time)
    end

    def audio_view_count(s_date, e_date)
      q = "search sourcetype=wowza_access host=#{WOWZAHOST} stop stream 200 dmr mp3 | table x_spos"
      data = stats(q, s_date, e_date)
      tmp_count = 0
      data.each do |result|
        tmp = result.to_s.split('=>"')[1].gsub!('"}', '').to_i
        tmp_count += 1 if tmp > AUDIO_MIN_PLAYTIME
      end
      tmp_count
    end

    def process_count(data, stop_time)
      tmp_view = {}
      data.each do |result|
        tmp = result['_raw'].to_s.split
        if stop_time.key?(process_id(tmp))
          time_diff = Time.diff(tmp[1], stop_time[process_id(tmp)])[:minute]
          tmp_view[process_id(tmp)] = time_diff if time_diff >= 5
        end
      end
      unique_count(tmp_view)
    end

    def unique_count(view)
      key_prefix = ''
      key_array = []
      view.keys.sort.each { |key|
        key_prefix = "#{key.split('-')[0]}-#{key.split('-')[1]}"
        key_array << key_prefix if !key_array.include?(key_prefix)
      }
      key_array.length
    end

    def stop_time_view(s_date, e_date)
      q = "search sourcetype=wowza_access host=#{WOWZAHOST} stop stream 200 dmr"
      data = stats(q, s_date, e_date)
      files = {}
      data.each do |result|
        tmp_result = result['_raw'].to_s.split
        files[process_id(tmp_result)] = tmp_result[1]
      end
      files
    end

    def process_id(row)
      "#{row[7]}-#{row[row.length - 18]}-#{row[row.length - 15]}"
    end

    def convert_time(date, time)
      if DateTime.current.strftime('%m/%d/%Y').include?(date) && time.include?('PM')
        d_time = 'now'
      else
        d_time = DateTime.strptime("#{date} #{time}", '%m/%d/%Y %H:%M:%S%z')
      end
      d_time
    end
  end
end
