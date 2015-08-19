require 'spec_helper'

describe "courses/index" do
  before(:each) do
    assign(:courses, [
      Course.create!(
        :quarter => "Quarter",
        :year => "2015",
        :course => "Course",
        :instructor => "Instructor"
      ),
      Course.create!(
        :quarter => "Quarter",
        :year => "2015",
        :course => "Course",
        :instructor => "Instructor"
      )
    ])
  end

  it "renders a list of courses" do
    render
    assert_select "tr>td", :text => "Quarter".to_s, :count => 2
    assert_select "tr>td", :text => "2015".to_s, :count => 2
    assert_select "tr>td", :text => "Course".to_s, :count => 2
    assert_select "tr>td", :text => "Instructor".to_s, :count => 2
  end
end
