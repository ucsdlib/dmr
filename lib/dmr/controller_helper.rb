#---
# @author Vivian <tchu@ucsd.edu>
#---

module Dmr
  module ControllerHelper 
    ##
    # Adds media objects to current course list
    #
    # @param filename [Array] set of Media's ids
    # @param current_course [String] Current Course ID
    #
    ##

    def add_media_to_course(media_ids,current_course)
      @course = Course.find_by_id(current_course.to_i) if current_course
      current_course_media_ids = @course.media.map(&:id) if @course.media
      add_to_report(media_ids, @course, current_course_media_ids)  
    end

    ##
    # Helper method to add media objects to the reports of current course list
    #
    # @param filename [Array] set of Media's ids
    # @param current_course [String] Current Course ID
    # @param filename [Array] set of Current Course Media's ids
    #
    ##
    def add_to_report(media_ids,current_course,current_course_media_ids)      
      counter = get_next_report_counter(current_course.id)
      if media_ids && current_course
        media_ids.each do |id|
          med = Media.find_by_id(id.to_i)
          if med && !current_course_media_ids.include?(id.to_i)
            current_course.reports.create(media: med, counter: counter.to_s)
          end 
          counter = get_next_report_counter(current_course.id)
        end
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
    def get_next_report_counter(course_id)
      next_counter = 1      
      report = Report.where(course_id: course_id).order(counter: :desc)
      next_counter = report.first.counter.to_i + 1 if report && report.first
      return next_counter     
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
    def get_counter(course_id, counter,counter_type)    
      next_counter = 0      
      if counter_type == "next"
        report = Report.where('course_id = ? and counter > ?',course_id, counter.to_s).order(counter: :asc)
      elsif counter_type == "previous"
        report = Report.where('course_id = ? and counter < ?',course_id, counter.to_s).order(counter: :desc)
      end
      next_counter = report.first.counter.to_i if report && report.first
      return next_counter 
    end
    
    ##
    # Updates the report for Course Reserve List
    #
    # @param course_id [Integer] Course ID
    # @param current_counter [Integer] the current report counter
    # @param new_counter [Integer] the new report counter
    #
    ##
    def update_report(course_id, current_counter, new_counter)         
      report = Report.where(course_id: course_id, counter: current_counter)
      update_report_counter(report, new_counter)  
    end

    ##
    # Get the previous report counter for Course Reserve List
    #
    # @param course_id [Integer] Course ID
    # @param counter [Integer] the report counter
    #
    ##
    def update_report_counter(report,counter)
      if report && report.first
        report.first.counter = counter
        report.first.save!        
      end          
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
      course.reports.sort{ |a,b| a.counter <=> b.counter }.each do |r|    
        media = Media.find_by_id(r.media_id)
        media_array << media if media
      end
      return media_array
    end
               
    ##
    # Removes media objects from course list
    #
    # @param filename [Array] set of Media's ids
    # @param course [Course] Course object
    #
    ##
    def remove_media_from_course(media_ids,course)
      if media_ids && course
        media_ids.each do |id|
          report_tag=Report.where(course_id: course.id, media_id: id.to_i)
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
    def move_up(course,current_counter,report)      
      if current_counter > 1 
        pre_counter=get_counter(course.id,current_counter,"previous")          
        update_report(course.id,pre_counter,current_counter)
        update_report_counter(report,pre_counter)
      end          
    end

    ##
    # Moves media object down one from course list
    #
    # @param filename [Array] set of Media's ids
    # @param course [String] Current Course ID
    #
    ##    
    def move_down(course,current_counter,report)      
      if current_counter < course.reports.size
        next_counter = get_counter(course.id, current_counter,"next") 
        update_report(course.id, next_counter, current_counter)
        update_report_counter(report, next_counter)
      end         
    end 

    ##
    # Change order of media object list in course list
    #
    # @param filename [Array] set of Media's ids
    # @param course [String] Current Course ID
    # @param type [String] submit type
    #
    ##       
    def change_media_order(media_ids, course, type)
      if media_ids && course
        current_counter = 0
        media_ids.each do |id|
          report = Report.where(course_id: course.id, media_id: id.to_i)      
          current_counter = report.first.counter.to_i if report && report.first
          move_up(course, current_counter, report) if(type == "Move Up One")
          move_down(course, current_counter, report) if (type == "Move Down One")
        end
      end          
    end

    ##
    # Removes selected media objects
    #
    # @param filename [Array] set of Media's ids
    #
    ##
    def delete_media(media_ids)
      media_ids.each do |id|
        media = Media.find(id.to_i)
        report_tags = Report.where(media_id: id.to_i)
        report_tags.each do |tag|     
          course = Course.find(tag.course_id)
          course.reports.delete(tag)      
        end
        media.destroy
      end 
    end                                             
  end
end
