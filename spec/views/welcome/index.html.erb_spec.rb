require 'spec_helper'

describe "welcome/index" do
  it "renders a welcome page" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Welcome to Digital Media Reserves/)
    rendered.should match(/Please Sign In/)     
  end
end
