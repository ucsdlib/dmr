# encoding: utf-8
require 'spec_helper'

feature 'Course' do
  before(:all) do
    @course1 = Course.create course: 'Test Course 1', instructor: 'Test Instructor 1', year: '2015', quarter: 'Spring'
    @course2 = Course.create course: 'Test Course 2', instructor: 'Test Instructor 2', year: '2015', quarter: 'Summer'
    @course3 = Course.create course: 'Course 3', instructor: 'Instructor 3', year: '9999', quarter: 'Summer'
    @course4 = Course.create course: 'Course 4', instructor: 'Instructor 4', year: '2015', quarter: 'Fall'
    @media1 = Media.create title: 'Test Media 1', director: 'Test Director 1', year: '2015', call_number: '11111111', file_name: 'toystory.mp4'
    @media2 = Media.create title: 'Test Media 2', director: 'Test Director 2', year: '2016', call_number: '77777777', file_name: 'file2.mp4'          
    @media3 = Media.create title: 'Test Media 3', director: 'Test Director 1', year: '2015', call_number: '11111111', file_name: 'toystory.mp4'
    @media4 = Media.create title: 'Test Media 4', director: 'Test Director 2', year: '2016', call_number: '77777777', file_name: 'file2.mp4'  
    @media5 = Media.create title: 'Test Media 5', director: 'Test Director 1', year: '2015', call_number: '11111111', file_name: 'toystory.mp4'
    @media6 = Media.create title: 'Test Media 6', director: 'Test Director 2', year: '2016', call_number: '77777777', file_name: 'file2.mp4' 
    @media7 = Media.create title: 'Test Media 7', director: 'Test Director 2', year: '2016', call_number: '77777777', file_name: 'file2.mp4'         
    @media8 = Media.create title: 'Test Media 8', director: 'Test Director 1', year: '2015', call_number: '11111111', file_name: 'toystory.mp4'
    @media9 = Media.create title: 'Test Media 9', director: 'Test Director 2', year: '2016', call_number: '77777777', file_name: 'file2.mp4'
    @media10 = Media.create title: 'Test Media 10', director: 'Test Director 1', year: '2015', call_number: '11111111', file_name: 'toystory.mp4'
  end
  after(:all) do
    @course1.delete
    @course2.delete
    @course3.delete
    @course4.delete
    @media1.delete
    @media2.delete
    @media3.delete
    @media4.delete
    @media5.delete
    @media6.delete
    @media7.delete
    @media8.delete
    @media9.delete
    @media10.delete
  end
  before(:each) do
    sign_in_developer
  end
  after(:each) do
    sign_out_developer
  end    
  scenario 'is on course index page' do
    visit courses_path
    expect(page).to have_selector('h3', :text => 'Listing Courses')
    expect(page).to have_selector('th[1]', :text => 'Course')
    expect(page).to have_selector('th[2]', :text => 'Quarter')
    expect(page).to have_selector('th[3]', :text => 'Year')
    expect(page).to have_selector('th[4]', :text => 'Instructor') 
    expect(page).to have_content('Test Course 1')
    expect(page).to have_content('Test Course 2')
  end
  
  scenario 'is on the course show page' do
    visit course_path(@course1)
    expect(page).to have_content('Test Course 1 Spring 2015')
  end
  
  scenario 'is on create new course page' do
    visit new_course_path
    page.select('Winter', match: :first) 
    fill_in 'Year', :with => '2009'
    fill_in 'Course', :with => 'Test Course 3'
    fill_in 'Instructor', :with => 'Test Instructor 3'
    click_on 'Start Course Reserve List'
    expect(page).to have_content('Course was successfully created.')

    # Check that changes are saved
    visit courses_path
    expect(page).to have_content('Test Course 3')
    expect(page).to have_content('Test Instructor 3')
    expect(page).to have_content('Winter')
    expect(page).to have_content('2009')                  
  end
  
  scenario 'is on the course page to be edited' do
    visit edit_course_path(@course1)
    expect(page).to have_selector('h3', :text => 'Course Reserve List')
    expect(page).to have_selector("input#course_course[value='Test Course 1']")
    expect(page).to have_selector("input#course_instructor[value='Test Instructor 1']")
    expect(page).to have_selector("input#course_year[value='2015']")
    expect(page).to have_selector("select#course_quarter/option[@selected='selected'][value='Spring']")
    
    # Update values
    page.select('Summer', match: :first)
    fill_in 'Course', :with => 'Test Course 1 Update'
    fill_in 'Instructor', :with => 'Test Instructor 1 Update'
    fill_in 'Year', :with => '2011'
    click_on('Save')
    expect(page).to have_content('Course successfully updated.')
        
    # Check that changes are saved
    expect(page).to have_selector('h3', :text => 'Course Reserve List')
    expect(page).to have_selector("input#course_course[value='Test Course 1 Update']")
    expect(page).to have_selector("input#course_instructor[value='Test Instructor 1 Update']")
    expect(page).to have_selector("input#course_year[value='2011']")
    expect(page).to have_selector("select#course_quarter/option[@selected='selected'][value='Summer']")
  end
  
  scenario 'wants to delete a course record' do
    visit edit_course_path(@course1)
    expect(page).to have_selector("input#course_course[value='Test Course 1']")
    click_on('Delete')
    expect(page).to have_content('Course was successfully destroyed.')
    expect(Course.count).to eq(3)
    visit courses_path
    expect(page).to_not have_content('Test Course 1')           
  end

  scenario 'wants to add a media object to the current Course Reserve List when no current course is set' do
    visit edit_medium_path(@media1)
    click_on 'Add to Course Reserve List'
    expect(page).to have_content('No current Course is set.  Set the Course first.')     
  end  
    
  scenario 'wants to add a media object to the current Course Reserve List from media edit page' do
    # set current course
    visit edit_course_path(@course1)
    
    #add to course list  
    visit edit_medium_path(@media1)
    click_on 'Add to Course Reserve List'
    
    #Check that changes are saved
    expect(page).to have_content('Media was successfully added to Course.')
    current_path.should == edit_course_path(@course1)
    expect(@course1.media.size).to eq(1)
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Director 1')         
  end
  
  scenario 'wants to add multiple media objects to the current Course Reserve List from media search results page' do
    # set current course 
    visit edit_course_path(@course1)

    # search for media objects
    visit search_media_path( {:search => 'Test'} )  
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Showing all 10 media')   
        
    # add to course list    
    find("input[type='checkbox'][value='#{@media1.id}']").set(true)
    find("input[type='checkbox'][value='#{@media2.id}']").set(true)
    click_on 'Add to Course Reserve List'
    
    #Check that changes are saved
    expect(page).to have_content('Media was successfully added to Course.')
    current_path.should == edit_course_path(@course1)
    expect(@course1.media.size).to eq(2)
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Director 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Test Director 2')                    
  end
  
  scenario 'wants to search for courses with a matching search term' do
    visit search_courses_path( {:search => 'Test'} )  
    expect(page).to have_content('Test Course 1')
    expect(page).to have_content('Test Course 2')
    expect(page).to have_content('Displaying 2 results')        
  end

  scenario 'wants to search for courses with exact string match with quotes' do
    visit search_courses_path( {:search => '"Test Course 1"'} )  
    expect(page).to have_content('Test Course 1')
    expect(page).to have_content('Displaying 1 results')        
  end
  
  scenario 'wants to do combined searches for Courses' do
    visit search_courses_path( {:search => 'Test 9999 Summer'} )  
    expect(page).to have_content('Test Course 1')
    expect(page).to have_content('Test Course 2')
    expect(page).to have_content('9999')
    expect(page).to have_content('Summer')
    expect(page).to have_content('Displaying 3 results')        
  end

  scenario 'wants to do search for quarter and year' do
    visit search_courses_path( {:search => 'spring 2015'} )
    expect(page).to have_content('Displaying 1 results')
    expect(page).to have_content('Test Course 1')
    expect(page).to have_content('Spring')
    expect(page).to have_content('2015')
  end
      
  scenario 'wants to search for courses with no matching search term' do    
    visit search_courses_path( {:search => 'abcdef'} )
    expect(page).to have_content('There were no results for the search: "abcdef"')        
  end
  
  scenario "wants to select 'courses' option to search for courses" do
    visit search_courses_path( {:search => 'Test',:search_option => 'courses'} )  
    expect(page).to have_content('Test Course 1')
    expect(page).to have_content('Test Course 2')
    expect(page).to have_content('Displaying 2 results')
    
    #Check that the search_option radio button is still selected
    find("input[name='search_option'][type='radio'][value='courses']").should be_checked        
  end
  
  scenario 'wants to remove media from Course Reserve List' do
    # set current course   
    visit edit_course_path(@course1) 
     
    # search for media objects
    visit search_media_path( {:search => 'Test'} )  
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Showing all 10 media')   
        
    # add to course list    
    find("input[type='checkbox'][value='#{@media1.id}']").set(true)
    find("input[type='checkbox'][value='#{@media2.id}']").set(true)
    click_on 'Add to Course Reserve List'
    
    #Check that changes are saved
    expect(page).to have_content('Media was successfully added to Course.')
    current_path.should == edit_course_path(@course1)
    expect(@course1.media.size).to eq(2)
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Director 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Test Director 2')
    
    # select media object and click the 'Remove Item(s)' button
    find("input[type='checkbox'][value='#{@media1.id}']").set(true)
    click_on 'Remove Item(s)'
    
    # Check that selected media object does not exist
    expect(page).to have_content('Course successfully updated.')
    current_path.should == edit_course_path(@course1)
    expect(@course1.media.size).to eq(1)
    expect(page).to_not have_content('Test Media 1')
    expect(page).to_not have_content('Test Director 1')                   
  end 
  
  scenario 'wants to clone a Course Reserve List' do
    # set current course   
    visit edit_course_path(@course1) 
    
    # add media to course 
    visit edit_medium_path(@media1)
    click_on 'Add to Course Reserve List'  

    #Check that changes are saved
    expect(page).to have_content('Media was successfully added to Course.')
    current_path.should == edit_course_path(@course1)
    
    click_on 'Clone'
    expect(page).to have_content('Course was successfully cloned.')
    current_path.should_not == edit_course_path(@course1) 

    #Check that changes are saved in new Course Reserve List
    expect(page).to have_selector("input#course_course[value='Test Course 1']")
    expect(page).to have_selector("input#course_instructor[value='Test Instructor 1']")
    expect(page).to have_selector("input#course_year[value='2015']")
    expect(page).to have_selector("select#course_quarter/option[@selected='selected'][value='Spring']")
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Director 1')              
  end
  
  scenario 'wants to move one media up in Course Reserve List' do
    # set current course   
    visit edit_course_path(@course1) 
     
    # search for media objects
    visit search_media_path( {:search => 'Test'} )  
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Showing all 10 media')   
        
    # add to course list    
    find("input[type='checkbox'][value='#{@media1.id}']").set(true)
    find("input[type='checkbox'][value='#{@media2.id}']").set(true)
    find("input[type='checkbox'][value='#{@media3.id}']").set(true)
    find("input[type='checkbox'][value='#{@media4.id}']").set(true)
    find("input[type='checkbox'][value='#{@media5.id}']").set(true)
    find("input[type='checkbox'][value='#{@media6.id}']").set(true)
    find("input[type='checkbox'][value='#{@media7.id}']").set(true)
    find("input[type='checkbox'][value='#{@media8.id}']").set(true)
    find("input[type='checkbox'][value='#{@media9.id}']").set(true)
    find("input[type='checkbox'][value='#{@media10.id}']").set(true)    
    click_on 'Add to Course Reserve List'
    
    #Check that changes are saved
    expect(page).to have_content('Media was successfully added to Course.')
    expect(@course1.media.size).to eq(10)  
    
    # check that media object is in order
    page.all('tr')[1].text.should include '1 Test Media 1'
    page.all('tr')[2].text.should include '2 Test Media 10' 
    
    # select 2nd media object and click the 'Move Up One' button
    find("input[type='checkbox'][value='#{@media10.id}']").set(true)
    click_on 'Move Up One' 
    
    # check that 2nd media object is displayed first
    page.all('tr')[1].text.should include '1 Test Media 10'
    page.all('tr')[2].text.should include '2 Test Media 1'               
  end
  
  scenario 'wants to move one media down in Course Reserve List' do
    # set current course   
    visit edit_course_path(@course1) 
     
    # search for media objects
    visit search_media_path( {:search => 'Test'} )  
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Showing all 10 media')   
        
    # add to course list    
    find("input[type='checkbox'][value='#{@media1.id}']").set(true)
    find("input[type='checkbox'][value='#{@media2.id}']").set(true)
    find("input[type='checkbox'][value='#{@media3.id}']").set(true)
    find("input[type='checkbox'][value='#{@media4.id}']").set(true)
    find("input[type='checkbox'][value='#{@media5.id}']").set(true)
    find("input[type='checkbox'][value='#{@media6.id}']").set(true)
    find("input[type='checkbox'][value='#{@media7.id}']").set(true)
    find("input[type='checkbox'][value='#{@media8.id}']").set(true)
    find("input[type='checkbox'][value='#{@media9.id}']").set(true)
    find("input[type='checkbox'][value='#{@media10.id}']").set(true)       
    click_on 'Add to Course Reserve List'
    
    #Check that changes are saved
    expect(page).to have_content('Media was successfully added to Course.')
    expect(@course1.media.size).to eq(10)  
    
    # check that media object is in order
    page.all('tr')[1].text.should include '1 Test Media 1'
    page.all('tr')[2].text.should include '2 Test Media 10' 
    
    # select first media object and click the 'Move Down One' button
    find("input[type='checkbox'][value='#{@media1.id}']").set(true)
    click_on 'Move Down One' 
    
    # check that first media object is displayed 2nd
    page.all('tr')[1].text.should include '1 Test Media 10'
    page.all('tr')[2].text.should include '2 Test Media 1'               
  end
  
  scenario 'expects to see a friendly url Course Reserve List' do
    # set current course   
    visit edit_course_path(@course1) 
     
    # search for media objects
    visit search_media_path( {:search => 'Test'} )  
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Showing all 10 media')   
        
    # add to course list    
    find("input[type='checkbox'][value='#{@media1.id}']").set(true)
    find("input[type='checkbox'][value='#{@media2.id}']").set(true)
    click_on 'Add to Course Reserve List'
    
    # check the friendly url for view button
    expect(page).to have_link('View', href: 'Spring/2015/test_course_1' )
    click_on 'View'
    
    current_path.should == "/courses/#{@course1.id}/#{@course1.quarter}/#{@course1.year}/#{@course1.course.parameterize("_")}"           
  end
  
  scenario 'wants to send a Course Reserve List confirmation email' do  
    visit edit_course_path(@course1) 
    click_on 'Send List' 
    expect(page).to have_content('The confirmation email has been sent.')      
  end
  
  scenario 'automatically set the course being edit to current course' do
    visit edit_course_path(@course1)
    click_on 'View Current Course Reserve List'
    current_path.should == edit_course_path(@course1)        
  end

  scenario 'wants to cancel search courses' do
    visit welcome_index_path
    click_on 'Archive'
    expect(page).to have_selector('h3', :text => 'Search Courses')
    fill_in 'course_q', :with => 'Test'
    click_on 'Cancel'
    current_path.should == welcome_index_path     
  end
    
  scenario 'wants to archive some courses' do
    visit search_courses_path( {:search => 'Test'} )    
    expect(page).to have_content('Displaying 2 results')
    expect(page).to have_content('Test Course 1')
    expect(page).to have_content('Test Course 2')
        
    # select courses to archive   
    find("input[type='checkbox'][value='#{@course1.id}']").set(true)
    find("input[type='checkbox'][value='#{@course2.id}']").set(true)
    find('input[value="Archive"]').click
    current_path.should == courses_path
    expect(page).to have_content('Courses were successfully archived.')
    expect(page).to have_content("Test Course 1 - ARCHIVE #{@course1.updated_at}")
    expect(page).to have_content("Test Course 2 - ARCHIVE #{@course2.updated_at}")
    click_on "Test Course 1 - ARCHIVE #{@course1.updated_at}"
    report_url = "Spring/2015/test_course_1_-_archive_#{@course1.updated_at.to_s.parameterize("_")}"
    expect(page).to have_link('View', href: "#{report_url}" )
    click_on "View"
    current_path.should == "/courses/#{@course1.id}/#{report_url}"    
  end 

  scenario 'wants to search for archived course' do
    visit search_courses_path( {:search => 'Test'} )    
    expect(page).to have_content('Displaying 2 results')
    expect(page).to have_content('Test Course 1')
    expect(page).to have_content('Test Course 2')
        
    # select courses to archive   
    find("input[type='checkbox'][value='#{@course1.id}']").set(true)
    find('input[value="Archive"]').click
    current_path.should == courses_path
    expect(page).to have_content('Courses were successfully archived.')
    expect(page).to have_content("Test Course 1 - ARCHIVE #{@course1.updated_at}")
      
    visit welcome_index_path
    click_on 'Archive'
    expect(page).to have_selector('h3', :text => 'Search Courses')
    fill_in 'year_q', :with => '2015'
    click_on 'Search'
    expect(page).to have_content('Displaying 1 results')
    expect(page).to have_content("Test Course 1 - ARCHIVE #{@course1.updated_at}")    
  end
  
  scenario 'fails to archive some courses' do
    visit search_courses_path( {:search => 'Test'} )    
    expect(page).to have_content('Displaying 2 results')
    expect(page).to have_content('Test Course 1')
    expect(page).to have_content('Test Course 2')
        
    # no course is selected   
    find('input[value="Archive"]').click
    current_path.should == courses_path
    expect(page).to have_content('Courses were failed to archive.')
  end
  
  scenario 'fails to view old report url after the course is archived' do
    # report url works before archiving a course
    visit edit_course_path(@course1)
    report_url = "Spring/2015/test_course_1"
    expect(page).to have_link('View', href: "#{report_url}" )
    click_on "View"
    current_path.should == "/courses/#{@course1.id}/#{report_url}"  
        
    # archive a course    
    visit search_courses_path( {:search => 'Test'} )  
    expect(page).to have_content('Test Course 1')
        
    find("input[type='checkbox'][value='#{@course1.id}']").set(true)  
    find('input[value="Archive"]').click
    expect(page).to have_content('Courses were successfully archived.')
    
    visit edit_course_path(@course1)
    expect(page).to_not have_link('View', href: "#{report_url}" )

    # view old report url
    visit "/courses/#{@course1.id}/#{report_url}"
    expect(page).to have_content('The page you were looking for doesn\'t exist')
  end                                                     
end