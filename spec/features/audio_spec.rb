# encoding: utf-8
require 'spec_helper'

feature 'Audio' do
  before(:all) do
    @audio1 = Audio.create track: 'Test Audio 1', album: 'Album 1', artist: 'Artist 1', composer: 'Composer 1', year: '2015', call_number: '11111111', file_name: 'pureAwareness.mp3'
    @audio2 = Audio.create track: 'Test Audio 2', album: 'Album 2', artist: 'Artist 2', composer: 'Composer 2', year: '2016', call_number: '77777777', file_name: 'test.mp3'    
  end
  after(:all) do
    @audio1.delete
    @audio2.delete
  end
  before(:each) do
    sign_in_developer
  end
  after(:each) do
    sign_out_developer
  end  
  scenario 'is on audio index page' do
    visit audios_path
    expect(page).to have_content('Listing Audios')   
    expect(page).to have_content('Test Audio 1')
    expect(page).to have_content('Test Audio 2')
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
    expect(Audio.count).to eq(2)
    
    visit edit_audio_path(@audio1)
    expect(page).to have_selector("input#audio_track[value='Test Audio 1']")
    click_on('Delete')
    expect(page).to have_content('Audio was successfully destroyed.')
    expect(Audio.count).to eq(1)
    visit audios_path
    expect(page).to_not have_content('Test Audio 1')           
  end   
                          
end