# encoding: utf-8
require 'spec_helper'

feature 'Audio' do
  before(:all) do
    @audio1 = Audio.create track: 'Test Audio 1', album: 'Album 1', artist: 'Artist 1', composer: 'Composer 1', year: '2015', call_number: '11111111', file_name: 'pureAwareness.mp3'
    @audio2 = Audio.create track: 'Test Audio 2', album: 'Album 2', artist: 'Artist 2', composer: 'Composer 2', year: '2016', call_number: '77777777', file_name: 'test.mp3'    
    @audio3 = Audio.create track: 'Combined Search Title', album: 'Album 3', artist: 'Artist 3', composer: 'Composer 3', year: '1999', call_number: '88888888', file_name: 'combine.mp3'    
  end
  after(:all) do
    @audio1.delete
    @audio2.delete
    @audio3.delete
  end
  before(:each) do
    sign_in_developer
  end
  after(:each) do
    sign_out_developer
  end  
  scenario 'is on audio index page' do
    visit audios_path
    expect(page).to have_content('Listing Audio')   
    expect(page).to have_content('Test Audio 1')
    expect(page).to have_content('Test Audio 2')
    expect(page).to have_selector('th[3]', :text => 'Track')
    expect(page).to have_selector('th[4]', :text => 'Album')
    expect(page).to have_selector('th[5]', :text => 'Artist')
    expect(page).to have_selector('th[6]', :text => 'Composer')
    expect(page).to have_selector('th[7]', :text => 'Call Number')
    expect(page).to have_selector('th[8]', :text => 'Year')
    expect(page).to have_selector('th[9]', :text => 'File Name')     
  end

  scenario "is on audio index page with 'Create New Audio Record' button" do
    visit audios_path
    expect(page).to have_selector('h3', :text => 'Listing Audio')
    expect(page).to have_selector('a.btn-primary', :text => 'Create New Audio Record')
  end
   
  scenario 'is on the audio show page' do
    visit audio_path(@audio1)
    expect(page).to have_content(@audio1.track)
    expect(page).to have_content('Loading the player...')
  end
  
  scenario 'is on create new audio record page' do
    visit new_audio_path
    fill_in 'Track', :with => 'Test Audio 3'
    fill_in 'Album', :with => 'Test Album 3'
    fill_in 'Artist', :with => 'Test Artist 3'
    fill_in 'Composer', :with => 'Test Composer 3'
    fill_in 'Year', :with => '2015'
    fill_in 'Call Number', :with => 'bb22222222'
    fill_in 'File Name', :with => 'test.mp3'
    click_on 'Save'
    expect(page).to have_content('Audio was successfully created.')

    # Check that changes are saved
    visit audios_path
    expect(page).to have_content('Test Audio 3')
    expect(page).to have_content('Test Album 3')
    expect(page).to have_content('Test Artist 3')
    expect(page).to have_content('Test Composer 3')
    expect(page).to have_content('2015')
    expect(page).to have_content('bb22222222')
    expect(page).to have_content('test.mp3')                  
  end
  
  scenario 'is on the audio page to be edited' do
    visit edit_audio_path(@audio1)
    expect(page).to have_selector('h3', :text => 'Audio Record Core Data')
    expect(page).to have_selector("input#audio_track[value='Test Audio 1']")
    expect(page).to have_selector("input#audio_album[value='Album 1']")
    expect(page).to have_selector("input#audio_artist[value='Artist 1']")
    expect(page).to have_selector("input#audio_composer[value='Composer 1']")
    expect(page).to have_selector("input#audio_year[value='2015']")
    expect(page).to have_selector("input#audio_call_number[value='11111111']")
    expect(page).to have_selector("input#audio_file_name[value='pureAwareness.mp3']")
    page.find('.media-thumbnail')['src'].should have_content "#{Rails.configuration.audio_file_path}#{@audio1.file_name.gsub('.mp3','.jpg')}" 

    # Update values
    fill_in 'Track', :with => 'Test Audio 1 Update'
    fill_in 'Album', :with => 'Album 1 Update'
    fill_in 'Artist', :with => 'Artist 1 Update'
    fill_in 'Composer', :with => 'Composer 1 Update'
    fill_in 'Year', :with => '2017'
    fill_in 'Call Number', :with => '33333333'    
    fill_in 'File Name', :with => 'test.mp3'   
    click_on('Save')
    expect(page).to have_content('Audio was successfully updated.')
        
    # Check that changes are saved
    expect(page).to have_selector('h3', :text => 'Audio Record Core Data')
    expect(page).to have_selector("input#audio_track[value='Test Audio 1 Update']")
    expect(page).to have_selector("input#audio_album[value='Album 1 Update']")
    expect(page).to have_selector("input#audio_artist[value='Artist 1 Update']")
    expect(page).to have_selector("input#audio_composer[value='Composer 1 Update']")
    expect(page).to have_selector("input#audio_year[value='2017']")
    expect(page).to have_selector("input#audio_call_number[value='33333333']")
    expect(page).to have_selector("input#audio_file_name[value='test.mp3']")             
  end
  
  scenario 'wants to delete a audio record' do
    visit audios_path   
    expect(page).to have_content('Test Audio 1')
    expect(page).to have_content('Test Audio 2')  
    expect(Audio.count).to eq(3)
    
    visit edit_audio_path(@audio1)
    expect(page).to have_selector("input#audio_track[value='Test Audio 1']")
    click_on('Delete')
    expect(page).to have_content('Audio was successfully destroyed.')
    expect(Audio.count).to eq(2)
    visit audios_path
    expect(page).to_not have_content('Test Audio 1')           
  end   

  scenario 'wants to view audio drop down menu' do
    visit root_path   
    expect(page).to have_content('Create New Audio Record')
    expect(page).to have_content('View Last 10 Audio Records')        
  end
  
  scenario 'wants to search for Audio with a matching search term' do
    visit search_audios_path( {:search => 'Test'} )  
    expect(page).to have_content('Test Audio 1')
    expect(page).to have_content('Test Audio 2')
    expect(page).to have_content('Displaying 2 results')        
  end

  scenario 'wants to do combined searches for Audio' do
    visit search_audios_path( {:search => 'Test 1999'} )  
    expect(page).to have_content('Test Audio 1')
    expect(page).to have_content('Test Audio 2')
    expect(page).to have_content('1999')
    expect(page).to have_content('Displaying 3 results')        
  end
   
  scenario 'wants to search for Audio with no search term' do
    visit search_audios_path( {:search => ''} )  
    expect(page).to have_content('No text is inputted.')
  end
   
  scenario 'wants to search for Audio with no matching search term' do    
    visit search_audios_path( {:search => 'abcdef'} )
    expect(page).to have_content('There were no results for the search: "abcdef"')        
  end

  scenario 'wants to search for Audio with exact string match with quotes' do    
    visit search_audios_path( {:search => '"Test Audio"'} )
    expect(page).to have_content('Test Audio 1')
    expect(page).to have_content('Test Audio 2')
    expect(page).to have_content('Displaying 2 results')
  end
  
  scenario 'wants to search for Audio file name' do
    visit search_audios_path( {:search => 'pureAwareness'} )  
    expect(page).to have_content('Displaying 1 result')   
    expect(page).to have_content('Test Audio 1')
    expect(page).to have_content('pureAwareness.mp3') 
  end

  scenario "wants to select 'audio' option to search for Audio" do
    visit search_media_path( {:search => 'Test',:search_option => 'audio'} )  
    expect(page).to have_content('Test Audio 1')
    expect(page).to have_content('Test Audio 2')
    expect(page).to have_content('Displaying 2 results')
    
    #Check that the search_option radio button is still selected
    find("input[name='search_option'][type='radio'][value='audio']").should be_checked        
  end                             
end