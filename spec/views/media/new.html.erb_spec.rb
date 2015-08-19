require 'spec_helper'

describe "media/new" do
  before(:each) do
    @media = Fabricate(:media)
    assign(:media, @media)
  end
  
  it "renders new page form" do
    render :template => "media/new.html.erb"

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", media_path, "post" do
      assert_select "input#media_title[name=?]", "media[title]"    
      assert_select "input#media_director[name=?]", "media[director]"
      assert_select "input#media_year[name=?]", "media[year]"
      assert_select "input#media_call_number[name=?]", "media[call_number]"
      assert_select "input#media_file_name[name=?]", "media[file_name]"
    end
  end
end