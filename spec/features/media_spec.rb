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
    expect(page).to have_selector('h3', :text => 'Listing Media')
    expect(page).to have_selector('th[3]', :text => 'Title')
    expect(page).to have_selector('th[4]', :text => 'Director')
    expect(page).to have_selector('th[5]', :text => 'Call Number')
    expect(page).to have_selector('th[6]', :text => 'Year')
    expect(page).to have_selector('th[7]', :text => 'File Name')     
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')
  end
  
  scenario "is on the media show page" do
    visit medium_path(@media1)
    expect(page).to have_selector('h3', :text => @media1.title)
    expect(page).to have_content('Loading the player...')
  end
  
  scenario "is on create new media record page" do
    visit new_medium_path
    fill_in "Title", :with => "Test Media 3"
    fill_in "Director", :with => "Test Director 3"
    fill_in "Year", :with => "2015"
    fill_in "Call Number", :with => "bb22222222"
    fill_in "File Name", :with => "test.mp4"
    click_on "Save"
    expect(page).to have_content('Media was successfully created.')

    # Check that changes are saved
    visit media_path
    expect(page).to have_content('Test Media 3')
    expect(page).to have_content('Test Director 3')
    expect(page).to have_content('bb22222222')
    expect(page).to have_content('test.mp4')                  
  end
  
  scenario "is on the media page to be edited" do
    visit edit_medium_path(@media1)
    expect(page).to have_selector('h3', :text => 'Media Record Core Data')
    expect(page).to have_selector("input#media_title[value='Test Media 1']")
    expect(page).to have_selector("input#media_director[value='Test Director 1']")
    expect(page).to have_selector("input#media_year[value='2015']")
    expect(page).to have_selector("input#media_call_number[value='11111111']")
    expect(page).to have_selector("input#media_file_name[value='toystory.mp4']")
    page.find('.media-thumbnail')['src'].should have_content "/media/#{@media1.id}/#{@media1.file_name.gsub('.mp4','.jpg')}" 

    # Update values
    fill_in "Title", :with => "Test Media 1 Update"
    fill_in "Director", :with => "Test Director 1 Update"
    fill_in "Year", :with => "2017"
    fill_in "Call Number", :with => "33333333"    
    fill_in "File Name", :with => "toystoryUpdate.mp4"   
    click_on('Save')
    expect(page).to have_content('Media successfully updated.')
        
    # Check that changes are saved
    expect(page).to have_selector('h3', :text => 'Media Record Core Data')
    expect(page).to have_selector("input#media_title[value='Test Media 1 Update']")
    expect(page).to have_selector("input#media_director[value='Test Director 1 Update']")
    expect(page).to have_selector("input#media_year[value='2017']")
    expect(page).to have_selector("input#media_call_number[value='33333333']")
    expect(page).to have_selector("input#media_file_name[value='toystoryUpdate.mp4']")             
  end
  
  scenario "wants to delete a media record" do
    visit media_path   
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')  
    expect(Media.count).to eq(2)
    
    visit edit_medium_path(@media1)
    expect(page).to have_selector("input#media_title[value='Test Media 1']")
    click_on('Delete')
    expect(page).to have_content('Media was successfully destroyed.')
    expect(Media.count).to eq(1)
    visit media_path
    expect(page).to_not have_content('Test Media 1')           
  end   
  
  scenario "wants to search for a media record with a matching search term" do
    visit search_media_path( {:search => 'Test'} )  
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Showing all 2 media')        
  end
  
  scenario "wants to search for a media record with no matching search term" do    
    visit search_media_path( {:search => 'abcdef'} )
    expect(page).to have_content('There were no results for the search: "abcdef"')        
  end

  scenario "wants to return to search results page after viewing a media record" do
    visit search_media_path( {:search => 'Test'} )  
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Showing all 2 media')   
    click_on('Test Media 1')
    expect(page).to have_selector('h3', :text => 'Media Record Core Data')
    expect(page).to have_content('Return to Search Results')
    click_on('Return to Search Results')
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Showing all 2 media')           
  end

  scenario "wants to click on 'Play File' button on the media edit page" do
    visit edit_medium_path(@media1)
    expect(page).to have_selector("input#media_title[value='Test Media 1']")
    click_on('Play File')      
    expect(page).to have_selector('h3', :text => @media1.title)
    expect(page).to have_content('Loading the player...')
  end                        
end