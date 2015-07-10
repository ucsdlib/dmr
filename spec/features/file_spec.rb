require 'spec_helper'

feature "Image File" do
  before(:all) do
    @media = Media.create title: "Test Media 1", director: "Test Director 1", year: "2015", call_number: "77777777", file_name: "toystory.mp4"
  end
  after(:all) do
    @media.delete
  end
  
  scenario "should see the image file" do
    visit file_path( @media, "#{@media.file_name.gsub('.mp4','.jpg')}" )
    expect(page.driver.response.status).to eq( 200 )
    expect(response_headers['Content-Type']).to include 'image/jpeg'
  end  
end