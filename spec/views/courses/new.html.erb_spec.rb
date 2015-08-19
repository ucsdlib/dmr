require 'spec_helper'

describe "courses/new" do
  before(:each) do
    assign(:course, Course.new(
      :quarter => "MyString",
      :year => "2015",
      :course => "MyString",
      :instructor => "MyString"
    ))
  end

  it "renders new course form" do
    render

    assert_select "form[action=?][method=?]", courses_path, "post" do

      assert_select "select#course_quarter[name=?]", "course[quarter]"

      assert_select "input#course_year[name=?]", "course[year]"

      assert_select "input#course_course[name=?]", "course[course]"

      assert_select "input#course_instructor[name=?]", "course[instructor]"
    end
  end
end
