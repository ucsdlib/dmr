#
# @author Vivian <tchu@ucsd.edu>
#
module Dmr
  #
  # Collection of methods to support the Course Controller
  #
  module CourseControllerHelper
    ##
    # Helper method to archive course objects
    #
    # @param courses_ids [Array] set of Course's ids
    #
    ##
    def archive_courses?(courses_ids)
      return false unless courses_ids
      courses_ids.each do |id|
        tmp_course = Course.find_by_id(id.to_i)
        if tmp_course
          tmp_course.course = "#{tmp_course.course} - ARCHIVE #{tmp_course.updated_at}"
          tmp_course.save!
        end
      end
      true
    end

    ##
    # Helper method to unarchive course objects
    #
    # @param courses_ids [Array] set of Course's ids
    #
    ##
    def unarchive_courses?(courses_ids)
      return false unless courses_ids
      courses_ids.each do |id|
        tmp = Course.find_by_id(id.to_i)
        next unless tmp
        tmp_title = tmp.course.include?('ARCHIVE') ? tmp.course.split(' - ARCHIVE')[0] : tmp.course
        new_course = tmp.amoeba_dup
        new_course.course = tmp_title.to_s
        new_course.save!
        tmp.destroy
      end
      true
    end

    ##
    # Helper method to delete archived courses
    #
    # @param courses_ids [Array] set of Course's ids
    #
    ##
    def delete_archive(courses_ids)
      courses_ids.each do |id|
        tmp_course = Course.find_by_id(id.to_i)
        tmp_course.destroy if tmp_course
      end
    end

    ##
    # Handles search request for Course object
    #
    # @param query [String] the search query
    # @return [ActiveRecord::Relation] the resulting objects
    #
    def course_search(query)
      return unless query
      tokens = []
      if query.start_with?('"') && query.end_with?('"')
        query = query.delete('"')
      else
        tokens = query.split(' ')
      end
      fq = "course NOT LIKE '%ARCHIVE%'"
      q = "#{fq} AND lower(course || quarter || year || instructor) like ?"
      results = Course.where(q, "%#{query.downcase}%")
      q_quarter = ''
      q_year = ''
      tokens.each do |token|
        if token =~ /^(spring|summer|fall|winter)$/i
          q_quarter = " lower(quarter) like '%#{token.downcase}%'"
        elsif token =~ /^\d{4}$/
          q_year = " year like '%#{token}%'"
        else
          results = results.union(Course.where(q, "%#{token.downcase}%"))
        end
      end
      q_tmp = create_query(q_quarter, q_year)
      results = results.union(Course.where("#{fq} AND #{q_tmp}")) if q_tmp.present?
      results
    end

    def create_query(quarter, year)
      return "#{quarter}#{year}" unless quarter.present? && year.present?
      "#{quarter} AND #{year}"
    end

    def sorting(course, type, column)
      tmp_array = type == 'video' ? get_sorted_media(course) : get_sorted_audio(course)
      sort_column(tmp_array, column, course.id, type)
    end

    def sort_column(sorted_array, name, course_id, type)
      tmp_report = nil
      count = 1
      sorted_array.sort { |a, b| a.instance_eval(name) <=> b.instance_eval(name) }.each do |m|
        tmp_report = Report.where(course_id: course_id, media_id: m.id) if type == 'video'
        tmp_report = Audioreport.where(course_id: course_id, audio_id: m.id) if type == 'audio'
        update_report_counter(tmp_report, count)
        count += 1
      end
    end

    ##
    # Handles search request for Archived Course object
    #
    # @param query [String] the search query
    # @return [ActiveRecord::Relation] the resulting objects
    #
    def archive_full_search(params)
      return unless params
      inst = params[:instructor_q]
      q = "course LIKE '%ARCHIVE%'"
      q += " AND lower(course) like '%#{params[:course_q].downcase}%'" if params[:course_q].present?
      q += " AND year like '%#{params[:year_q]}%'" if params[:year_q].present?
      q += " AND lower(instructor) like '%#{inst.downcase}%'" if inst.present?
      Course.where(q)
    end
  end
end
