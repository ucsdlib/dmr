json.array!(@courses) do |course|
  json.extract! course, :id, :quarter, :year, :course, :instructor
  json.url course_url(course, format: :json)
end
