require 'spec_helper'

feature "Media" do
  before(:all) do
    @media1 = Media.create title: "Test Media 1", director: "Test Director 1", year: "2015", call_number: "11111111", file_name: "toystory.mp4"
    @media2 = Media.create title: "Test Media 2", director: "Test Director 2", year: "2016", call_number: "77777777", file_name: "file2.mp4"    
  end
  after(:all) do
    @media1.delete
    @media2.delete
  end
  
  scenario "is on media index page" do
    visit media_path
    expect(page).to have_selector('h1', :text => 'Listing Media')
    expect(page).to have_selector('th[1]', :text => 'Title')
    expect(page).to have_selector('th[2]', :text => 'Director')
    expect(page).to have_selector('th[3]', :text => 'Call Number')
    expect(page).to have_selector('th[4]', :text => 'Year')
    expect(page).to have_selector('th[5]', :text => 'File Name')     
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')
  end
  
  scenario "visits the media show page" do
    visit media_path
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')
    
    click_on('Test Media 1')
    expect(page).to have_selector('h2', :text => 'Media Record Core Data')
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Director 1')
    expect(page).to have_content('2015')
    expect(page).to have_content('11111111')
    expect(page).to have_content('toystory.mp4')
    page.find('.media-thumbnail')['src'].should have_content "/media/#{@media1.id}/#{@media1.file_name.gsub('.mp4','.jpg')}" 
  end  
end