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
    "#{media.end_date}/#{media.title.parameterize('_')}"
  end

  def audio_view_path(audio)
    "#{audio.end_date}/#{audio.track.parameterize('_')}"
  end
end
