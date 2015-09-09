#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe CourseMailer do
  before(:each) do
    @user = Fabricate(:user)
    @course = Fabricate(:course)
  end
  
  let(:email) {CourseMailer.course_email(@user, @course, nil)}
  
  it 'renders the subject' do
    expect(email.subject).to eql("DMR Confirmation for #{@course.course}")
  end
  
  it 'renders the receiver email' do
    expect(email.to).to eql(["landrews@ucsd.edu", "reserves@ucsd.edu", "#{@user.email}"])
  end
  
  it 'renders the sender email' do
    expect(email.from).to eql([@user.email])
  end
 
  it 'assigns course info' do
    expect(email.body.encoded).to match("#{@course.instructor}'s #{@course.course} course for #{@course.quarter} #{@course.year}.")
  end 

  it 'assigns course report friendly url' do
    url = "/courses/#{@course.id}/#{@course.quarter}/#{@course.year}/#{@course.course.parameterize("_")}"
    expect(email.body.encoded).to match(url)
  end       
end
