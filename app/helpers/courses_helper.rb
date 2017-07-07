#
# @author Vivian <tchu@ucsd.edu>
#
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

  def video_view_path(media)
    view_url(media)
  end

  def audio_view_path(audio)
    view_url(audio)
  end

  def view_url(obj)
    "#{obj.end_date}/#{obj.file_name}"
  end
end
