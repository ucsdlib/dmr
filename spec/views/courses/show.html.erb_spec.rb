require 'spec_helper'

describe "courses/show" do
  before(:each) do
    @course = assign(:course, Course.create!(
      :quarter => "Quarter",
      :year => "2015",
      :course => "Course",
      :instructor => "Instructor"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Course Quarter 2015/)
  end
end
