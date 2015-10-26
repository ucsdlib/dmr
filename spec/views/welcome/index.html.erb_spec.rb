# encoding: utf-8
require 'spec_helper'

describe 'welcome/index' do
  before(:each) do
    user = User.find_or_create_for_developer(nil)
    view.stub(:logged_in?).and_return(user)
    controller.stub(:logged_in?).and_return(user)
  end
  it 'renders an welcome page' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Search Media or Courses/)     
  end
end
