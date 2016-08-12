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
      if query
        tokens = query.split(' ')
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
        results = results.union(Course.where("#{fq} AND #{q_tmp}")) if !q_tmp.blank?
        results
      end
    end

    def create_query(quarter, year)
      return "#{quarter}#{year}" unless !quarter.blank? && !year.blank?
      "#{quarter} AND #{year}"
    end

    ##
    # Handles search request for Archived Course object
    #
    # @param query [String] the search query
    # @return [ActiveRecord::Relation] the resulting objects
    #
    def archive_full_search(params)
      if params
        inst = params[:instructor_q]
        q = "course LIKE '%ARCHIVE%'"
        q += " AND lower(course) like '%#{params[:course_q].downcase}%'" if !params[:course_q].blank?
        q += " AND lower(quarter) like '%#{params[:quarter_q].downcase}%'" if !params[:quarter_q].blank?
        q += " AND year like '%#{params[:year_q]}%'" if !params[:year_q].blank?
        q += " AND lower(instructor) like '%#{inst.downcase}%'" if !inst.blank?
        Course.where(q)
      end
    end
  end
end
