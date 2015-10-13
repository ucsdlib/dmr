# encoding: utf-8
module CoursesHelper
  ##
  # Builds friendly URL
  #
  # @param course [Course] the file name
  #
  # @return [String] url
  ##
  def course_report_path(course)
    "#{course.quarter}/#{course.year}/#{course.course.parameterize('_')}"
  end
end
