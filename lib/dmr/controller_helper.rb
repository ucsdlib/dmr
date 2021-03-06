#
# @author Vivian <tchu@ucsd.edu>
#
module Dmr
  #
  # Collection of methods to support the Controllers
  #
  module ControllerHelper
    ##
    # Adds media objects to current course list
    #
    # @param filename [Array] set of Media's ids
    # @param current_course [String] Current Course ID
    #
    ##

    def add_media_to_course(media_ids, current_course, type)
      @course = Course.find_by_id(current_course.to_i) if current_course
      current_course_media_ids = @course.media.map(&:id) if @course.media
      current_course_media_ids = @course.audios.map(&:id) if @course.audios
      add_to_report(media_ids, @course, current_course_media_ids, type)
    end

    ##
    # Helper method to add media objects to the reports of current course list
    #
    # @param filename [Array] set of Media's ids
    # @param current_course [String] Current Course ID
    # @param filename [Array] set of Current Course Media's ids
    #
    ##
    def add_to_report(media_ids, current_course, current_course_media_ids, type)
      counter = get_next_report_counter(current_course.id, type)
      return unless media_ids && current_course
      media_ids.each do |id|
        med = get_object(id.to_i, type)
        if med && !current_course_media_ids.include?(id.to_i)
          if type
            current_course.audioreports.create(audio: med, counter: counter.to_s)
          else
            current_course.reports.create(media: med, counter: counter.to_s)
          end
        end
        counter = get_next_report_counter(current_course.id, type)
      end
    end

    ##
    # Get the next report counter for Course Reserve List
    #
    # @param course_id [Integer] Course ID
    #
    # @return next_counter [Integer] the next report counter
    #
    ##
    def get_next_report_counter(course_id, type)
      next_counter = 1
      if type
        report = Audioreport.where(course_id: course_id).order('created_at DESC')
      else
        report = Report.where(course_id: course_id).order('created_at DESC')
      end
      next_counter = report.first.counter.to_i + 1 if report && report.first
      next_counter
    end

    ##
    # Get the previous or next report counter for Course Reserve List
    #
    # @param course_id [Integer] Course ID
    # @param current_counter [Integer] the current report counter
    # @param counter_type [String] previous or next counter type
    #
    # @return counter [Integer] the previous report counter
    #
    ##
    def get_counter(course_id, counter, counter_type, type)
      next_counter = 0
      counter_list = get_sorted_counter(Course.find(course_id), type)
      counter_pos = counter_list.index(counter.to_s)
      if counter_type == 'next'
        next_counter = counter_list[counter_pos + 1]
      elsif counter_type == 'previous'
        next_counter = counter_list[counter_pos - 1]
      end
      next_counter
    end

    ##
    # Updates the report for Course Reserve List
    #
    # @param course_id [Integer] Course ID
    # @param current_counter [Integer] the current report counter
    # @param new_counter [Integer] the new report counter
    #
    ##
    def update_report(course_id, current_counter, new_counter, type)
      if type
        report = Audioreport.where(course_id: course_id, counter: current_counter)
      else
        report = Report.where(course_id: course_id, counter: current_counter)
      end
      update_report_counter(report, new_counter)
    end

    ##
    # Get the previous report counter for Course Reserve List
    #
    # @param course_id [Integer] Course ID
    # @param counter [Integer] the report counter
    #
    ##
    def update_report_counter(report, counter)
      return unless report && report.first && counter
      report.first.counter = counter
      report.first.save!
    end

    ##
    # Sorts the media objects in the Course Reserve List
    #
    # @param course [Course] Course object
    #
    # @return media_array[Array] the list of Media object
    #
    ##
    def get_sorted_media(course)
      media_array = []
      course.reports.sort { |a, b| a.counter.to_i <=> b.counter.to_i }.each do |r|
        media = Media.find_by_id(r.media_id)
        media_array << media if media
      end
      media_array
    end

    ##
    # Sorts the audio objects in the Course Reserve List
    #
    # @param course [Course] Course object
    #
    # @return audio_array[Array] the list of Audio object
    #
    ##

    def get_sorted_audio(course)
      audio_array = []
      course.audioreports.sort { |a, b| a.counter.to_i <=> b.counter.to_i }.each do |r|
        audio = Audio.find_by_id(r.audio_id)
        audio_array << audio if audio
      end
      audio_array
    end

    ##
    # Returns the Audio or Video object based on the type
    #
    # @param id [String] object id
    # @param type [String] object type
    #
    # @return Audio or Video object
    #
    ##

    def get_object(id, type)
      if type
        obj = Audio.find_by_id(id)
      else
        obj = Media.find_by_id(id)
      end
      obj
    end

    ##
    # Sorts the media counter in the Course Reserve List
    #
    # @param course [Course] Course object
    #
    # @return counter_array[Array] the list of Media object counter
    #
    ##
    def get_sorted_counter(course, type)
      counter_array = []
      if type
        course.audioreports.sort { |a, b| a.counter.to_i <=> b.counter.to_i }.each do |r|
          counter_array << r.counter
        end
      else
        course.reports.sort { |a, b| a.counter.to_i <=> b.counter.to_i }.each do |r|
          counter_array << r.counter
        end
      end
      counter_array
    end

    ##
    # Removes media objects from course list
    #
    # @param filename [Array] set of Media's ids
    # @param course [Course] Course object
    #
    ##
    def remove_media_from_course(media_ids, course, type)
      return unless media_ids && course
      media_ids.each do |id|
        if type
          report_tag = Audioreport.where(course_id: course.id, audio_id: id.to_i)
          course.audioreports.delete(report_tag) if report_tag
        else
          report_tag = Report.where(course_id: course.id, media_id: id.to_i)
          course.reports.delete(report_tag) if report_tag
        end
      end
    end

    ##
    # Moves media object up one from course list
    #
    # @param filename [Array] set of Media's ids
    # @param course [String] Current Course ID
    #
    ##
    def move_up(course, current_counter, report, type)
      return unless current_counter > 1
      pre_counter = get_counter(course.id, current_counter, 'previous', type)
      update_report(course.id, pre_counter, current_counter, type)
      update_report_counter(report, pre_counter)
    end

    ##
    # Moves media object down one from course list
    #
    # @param filename [Array] set of Media's ids
    # @param course [String] Current Course ID
    #
    ##
    def move_down(course, current_counter, report, type)
      next_counter = get_counter(course.id, current_counter, 'next', type)
      update_report(course.id, next_counter, current_counter, type)
      update_report_counter(report, next_counter)
    end

    ##
    # Change order of media object list in course list
    #
    # @param filename [Array] set of Media's ids
    # @param course [String] Current Course ID
    # @param type [String] submit type
    #
    ##
    def change_media_order(media_ids, course, type, object_type)
      return unless media_ids && course
      current_counter = 0
      media_ids.each do |id|
        if object_type
          report = Audioreport.where(course_id: course.id, audio_id: id.to_i)
        else
          report = Report.where(course_id: course.id, media_id: id.to_i)
        end
        current_counter = report.first.counter.to_i if report && report.first
        move_up(course, current_counter, report, object_type) if type == 'Move Up One'
        move_down(course, current_counter, report, object_type) if type == 'Move Down One'
      end
    end

    ##
    # Removes selected media objects
    #
    # @param filename [Array] set of Media's ids
    #
    ##
    def delete_media(media_ids, type)
      media_ids.each do |id|
        media = get_object(id.to_i, type)
        report_tags = Report.where(media_id: id.to_i)
        report_tags = Audioreport.where(audio_id: id.to_i) if type
        report_tags.each do |tag|
          course = Course.find(tag.course_id)
          if type
            course.audioreports.delete(tag)
          else
            course.reports.delete(tag)
          end
        end
        media.destroy
      end
    end

    ##
    # Handles search request for Media or Audio object
    #
    # @param query [String] the search query
    # @return [ActiveRecord::Relation] the resulting objects
    #
    def full_search(query, model)
      return unless query
      tokens = []
      if query.start_with?('"') && query.end_with?('"')
        query = query.delete('"')
      else
        tokens = query.split(' ')
      end
      q = 'lower(title || director || year || call_number || file_name) like ?'
      if model.to_s.include?('Audio')
        q = 'lower(track || album || artist || composer || year || call_number || file_name) like ?'
      end
      results = model.where(q, "%#{query.downcase}%")
      tokens.each do |token|
        results = results.union(model.where(q, "%#{token.downcase}%"))
      end
      results
    end
  end
end
