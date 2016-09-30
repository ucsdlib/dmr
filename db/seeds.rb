# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
  if Rails.env.development? || Rails.env.test?
    Media.delete_all
    Course.delete_all
    Media.create!([
      { id: 1, title: 'Test Media 1', director: 'Director 1', year: '2011', call_number: '1111', file_name: 'toystory.mp4' },
      { id: 2, title: 'Test Media 2', director: 'Director 2', year: '2012', call_number: '2222', file_name: 'thematrix.mp4' },
      { id: 3, title: 'Test Media 3', director: 'Director 3', year: '2013', call_number: '3333', file_name: 'toystory.mp4' },
      { id: 4, title: 'Test Media 4', director: 'Director 4', year: '2014', call_number: '4444', file_name: 'thematrix.mp4' },
      { id: 5, title: 'Test Media 5', director: 'Director 5', year: '2015', call_number: '5555', file_name: 'toystory.mp4' }
    ])

    Course.create!([
      { id: 1, course: 'Test Course 1', instructor: 'Test Instructor 1', year: '2015', quarter: 'Spring' },
      { id: 2, course: 'Test Course 2', instructor: 'Test Instructor 2', year: '2016', quarter: 'Winter' }
    ])
    
    @course = Course.find(1)
    @course2 = Course.find(2)
    @media1 = Media.find(1)
    @media2 = Media.find(2)
    @course.reports.create!(media: @media1, counter: '1')
    @course.reports.create!(media: @media2, counter: '2')
    @course.save!
    @course2.course = "#{@course2.course} - ARCHIVE #{@course2.updated_at}"
    @course2.save!
  end