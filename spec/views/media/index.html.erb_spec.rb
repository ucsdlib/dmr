require 'spec_helper'

describe "media/index" do
  before(:all) do
    @media1 = Media.create title: "Test Media 1", director: "Test Director", year: "2015", call_number: "11111111", file_name: "file1.mp4"
    @media2 = Media.create title: "Test Media 2", director: "Test Director", year: "2015", call_number: "22222222", file_name: "file2.mp4"    
    assign(:medias, [@media1,@media2])
  end
  after(:all) do
    @media1.delete
    @media2.delete
  end
  
  it "renders a list of media" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Test Media 1".to_s, :count => 1
    assert_select "tr>td", :text => "Test Media 2".to_s, :count => 1
    assert_select "tr>td", :text => "Test Director".to_s, :count => 2
    assert_select "tr>td", :text => "2015".to_s, :count => 2
    assert_select "tr>td", :text => "11111111".to_s, :count => 1
    assert_select "tr>td", :text => "22222222".to_s, :count => 1
    assert_select "tr>td", :text => "file1.mp4".to_s, :count => 1
    assert_select "tr>td", :text => "file2.mp4".to_s, :count => 1           
  end
end
