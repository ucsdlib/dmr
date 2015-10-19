# encoding: utf-8
require 'spec_helper'

describe 'courses/edit' do
  before(:each) do
    @course = assign(:course, Course.create!(
      :quarter => 'MyString',
      :year => '2015',
      :course => 'MyString',
      :instructor => 'MyString'
    ))
  end

  it 'renders the edit course form' do
    render

    assert_select 'form[action=?][method=?]', course_path(@course), 'post' do

      assert_select 'select#course_quarter[name=?]', 'course[quarter]'

      assert_select 'input#course_year[name=?]', 'course[year]'

      assert_select 'input#course_course[name=?]', 'course[course]'

      assert_select 'input#course_instructor[name=?]', 'course[instructor]'
    end
  end
end
