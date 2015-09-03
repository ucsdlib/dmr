#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe CoursesHelper do

  describe "#course_report_path" do
    it "returns a friendly report url" do
      @course = Fabricate(:course)
      helper.course_report_path(@course).should eql("Spring/2015/test_course")
    end
  end
end
