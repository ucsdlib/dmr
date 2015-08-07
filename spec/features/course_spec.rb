require 'spec_helper'

feature "Course" do
  before(:all) do
    @course1 = Course.create course: "Test Course 1", instructor: "Test Instructor 1", year: "2015", quarter: "Spring"
    @course2 = Course.create course: "Test Course 2", instructor: "Test Instructor 2", year: "2015", quarter: "Summer"   
  end
  after(:all) do
    @course1.delete
    @course2.delete
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
    expect(page).to have_content('Test Course 1')
    expect(page).to have_content('Test Instructor 1')
    expect(page).to have_content('2015')
    expect(page).to have_content('Spring')
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
    #expect(page).to should have_select("course_quarter", :selected => 'Spring')
    #find("select#course_quarter").value.should eq('Spring')
    
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
end