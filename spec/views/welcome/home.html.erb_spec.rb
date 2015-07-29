require 'spec_helper'

describe "welcome/home" do
  it "renders a home page with search box" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Search Media or Courses .../)  
  end
end
