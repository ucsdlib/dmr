require 'spec_helper'

feature "Course" do
  before(:all) do
    @course1 = Course.create course: "Test Course 1", instructor: "Test Instructor 1", year: "2015", quarter: "Spring"
    @course2 = Course.create course: "Test Course 2", instructor: "Test Instructor 2", year: "2015", quarter: "Summer"
    @media1 = Media.create title: "Test Media 1", director: "Test Director 1", year: "2015", call_number: "11111111", file_name: "toystory.mp4"
    @media2 = Media.create title: "Test Media 2", director: "Test Director 2", year: "2016", call_number: "77777777", file_name: "file2.mp4"          
  end
  after(:all) do
    @course1.delete
    @course2.delete
    @media1.delete
    @media2.delete    
  end
  before(:each) do
    sign_in_developer
  end
  after(:each) do
    sign_out_developer
  end    
  scenario "is on course index page" do
    visit courses_path
    expect(page).to have_selector('h3', :text => 'Listing Courses')
    expect(page).to have_selector('th[1]', :text => 'Course')
    expect(page).to have_selector('th[2]', :text => 'Quarter')
    expect(page).to have_selector('th[3]', :text => 'Year')
    expect(page).to have_selector('th[4]', :text => 'Instructor') 
    expect(page).to have_content('Test Course 1')
    expect(page).to have_content('Test Course 2')
  end
  
  scenario "is on the course show page" do
    visit course_path(@course1)
    expect(page).to have_content('Test Course 1 Spring 2015')
  end
  
  scenario "is on create new course page" do
    visit new_course_path
    page.select('Winter', match: :first) 
    fill_in "Year", :with => "2009"
    fill_in "Course", :with => "Test Course 3"
    fill_in "Instructor", :with => "Test Instructor 3"
    click_on "Start Course Reserve List"
    expect(page).to have_content('Course was successfully created.')

    # Check that changes are saved
    visit courses_path
    expect(page).to have_content('Test Course 3')
    expect(page).to have_content('Test Instructor 3')
    expect(page).to have_content('Winter')
    expect(page).to have_content('2009')                  
  end
  
  scenario "is on the course page to be edited" do
    visit edit_course_path(@course1)
    expect(page).to have_selector('h3', :text => 'Course Reserve List')
    expect(page).to have_selector("input#course_course[value='Test Course 1']")
    expect(page).to have_selector("input#course_instructor[value='Test Instructor 1']")
    expect(page).to have_selector("input#course_year[value='2015']")
    expect(page).to have_selector("select#course_quarter/option[@selected='selected'][value='Spring']")
    
    # Update values
    page.select('Summer', match: :first)
    fill_in "Course", :with => "Test Course 1 Update"
    fill_in "Instructor", :with => "Test Instructor 1 Update"
    fill_in "Year", :with => "2011"
    click_on('Save')
    expect(page).to have_content('Course successfully updated.')
        
    # Check that changes are saved
    expect(page).to have_selector('h3', :text => 'Course Reserve List')
    expect(page).to have_selector("input#course_course[value='Test Course 1 Update']")
    expect(page).to have_selector("input#course_instructor[value='Test Instructor 1 Update']")
    expect(page).to have_selector("input#course_year[value='2011']")
    expect(page).to have_selector("select#course_quarter/option[@selected='selected'][value='Summer']")
  end
  
  scenario "wants to delete a course record" do
    visit edit_course_path(@course1)
    expect(page).to have_selector("input#course_course[value='Test Course 1']")
    click_on('Delete')
    expect(page).to have_content('Course was successfully destroyed.')
    expect(Course.count).to eq(1)
    visit courses_path
    expect(page).to_not have_content('Test Course 1')           
  end
  
  scenario "wants to set current Course Reserve List" do
    visit edit_course_path(@course1)
    click_on "Set Current Course"
    expect(page).to have_content('Current Course Reserve List was successfully set.')
    click_on "View Current Course Reserve List"
    current_path.should == edit_course_path(@course1)        
  end

  scenario "wants to add a media object to the current Course Reserve List when no current course is set" do
    visit edit_medium_path(@media1)
    click_on "Add to Course Reserve List"
    expect(page).to have_content('No current Course Reserve List is set. Please set the Course Reserve List first.')     
  end  
    
  scenario "wants to add a media object to the current Course Reserve List from media edit page" do
    # set current course
    visit edit_course_path(@course1)
    click_on "Set Current Course"
    
    #add to course list  
    visit edit_medium_path(@media1)
    click_on "Add to Course Reserve List"
    
    #Check that changes are saved
    expect(page).to have_content('Media was successfully added to the current Course Reserve List.')
    current_path.should == edit_course_path(@course1)
    expect(@course1.media.size).to eq(1)
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Director 1')         
  end
  
  scenario "wants to add multiple media objects to the current Course Reserve List from media search results page" do
    # set current course 
    visit edit_course_path(@course1)
    click_on "Set Current Course"  

    # search for media objects
    visit search_media_path( {:search => 'Test'} )  
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Showing all 2 media')   
        
    # add to course list    
    find("input[type='checkbox'][value='#{@media1.id}']").set(true)
    find("input[type='checkbox'][value='#{@media2.id}']").set(true)
    click_on "Add to Course Reserve List"
    
    #Check that changes are saved
    expect(page).to have_content('Media was successfully added to the current Course Reserve List.')
    current_path.should == edit_course_path(@course1)
    expect(@course1.media.size).to eq(2)
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Director 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Test Director 2')                    
  end
  
  scenario "wants to search for courses with a matching search term" do
    visit search_courses_path( {:search => 'Test'} )  
    expect(page).to have_content('Test Course 1')
    expect(page).to have_content('Test Course 2')
    expect(page).to have_content('Showing all 2 courses')        
  end
  
  scenario "wants to search for courses with no matching search term" do    
    visit search_courses_path( {:search => 'abcdef'} )
    expect(page).to have_content('There were no results for the search: "abcdef"')        
  end
  
  scenario "wants to select 'courses' option to search for courses" do
    visit search_courses_path( {:search => 'Test',:search_option => 'courses'} )  
    expect(page).to have_content('Test Course 1')
    expect(page).to have_content('Test Course 2')
    expect(page).to have_content('Showing all 2 courses')
    
    #Check that the search_option radio button is still selected
    find("input[name='search_option'][type='radio'][value='courses']").should be_checked        
  end
  
  scenario "wants to remove media from Course Reserve List" do
    # set current course   
    visit edit_course_path(@course1) 
    click_on "Set Current Course"
     
    # search for media objects
    visit search_media_path( {:search => 'Test'} )  
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Showing all 2 media')   
        
    # add to course list    
    find("input[type='checkbox'][value='#{@media1.id}']").set(true)
    find("input[type='checkbox'][value='#{@media2.id}']").set(true)
    click_on "Add to Course Reserve List"
    
    #Check that changes are saved
    expect(page).to have_content('Media was successfully added to the current Course Reserve List.')
    current_path.should == edit_course_path(@course1)
    expect(@course1.media.size).to eq(2)
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Director 1')
    expect(page).to have_content('Test Media 2')
    expect(page).to have_content('Test Director 2')
    
    # select media object and click the 'Remove Item(s)' button
    find("input[type='checkbox'][value='#{@media1.id}']").set(true)
    click_on "Remove Item(s)"
    
    # Check that selected media object does not exist
    expect(page).to have_content('Course successfully updated.')
    current_path.should == edit_course_path(@course1)
    expect(@course1.media.size).to eq(1)
    expect(page).to_not have_content('Test Media 1')
    expect(page).to_not have_content('Test Director 1')                   
  end 
  
  scenario "wants to clone a Course Reserve List" do
    # set current course   
    visit edit_course_path(@course1) 
    click_on "Set Current Course"
    
    # add media to course 
    visit edit_medium_path(@media1)
    click_on "Add to Course Reserve List"  

    #Check that changes are saved
    expect(page).to have_content('Media was successfully added to the current Course Reserve List.')
    current_path.should == edit_course_path(@course1)
    
    click_on "Clone"
    expect(page).to have_content('Course Reserve List was successfully cloned.')
    current_path.should_not == edit_course_path(@course1) 

    #Check that changes are saved in new Course Reserve List
    expect(page).to have_selector("input#course_course[value='Test Course 1']")
    expect(page).to have_selector("input#course_instructor[value='Test Instructor 1']")
    expect(page).to have_selector("input#course_year[value='2015']")
    expect(page).to have_selector("select#course_quarter/option[@selected='selected'][value='Spring']")
    expect(page).to have_content('Test Media 1')
    expect(page).to have_content('Test Director 1')              
  end                                    
end