require 'spec_helper'

describe "media/edit" do
  before(:each) do
    @media = Media.create title: "Test Media 1", director: "Test Director", year: "2015", call_number: "11111111", file_name: "toystory.mp4"
  end
  after(:all) do
    @media.delete
  end
    
  it "renders the edit page form" do
    render
    
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", medium_path(@media), "post" do
      assert_select "input#media_title[name=?]", "media[title]"
      assert_select "input#media_director[name=?]", "media[director]"
      assert_select "input#media_year[name=?]", "media[year]"
      assert_select "input#media_call_number[name=?]", "media[call_number]"
      assert_select "input#media_file_name[name=?]", "media[file_name]"        
    end
  end
end

