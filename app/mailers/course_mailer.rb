#---
# @author Vivian <tchu@ucsd.edu>
#---

class CourseMailer < ApplicationMailer
  ##
  # Sends an email
  #
  # @param user [User]
  # @param course [Course] the Course Reserve List
  # @param sorted_media [Array] the list of media belong to the course
  #
  
  def course_email(user, course, sorted_media)
    @course = course
    @sorted_media = sorted_media
    receiver_emails = "#{Rails.configuration.receiver_emails}#{user.email}"
    mail to: receiver_emails, from: user.email, subject: "DMR Confirmation for #{@course.course}"
  end
end
