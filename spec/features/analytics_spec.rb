# encoding: utf-8
require 'spec_helper'
require 'nokogiri'

feature 'Analytics' do
  before(:all) do
    @stat_new_courses = File.new('spec/fixtures/splunk_new_courses.xml').read 
    @stat_new_records = File.new('spec/fixtures/splunk_new_records.xml').read
    @stat_view = File.new('spec/fixtures/splunk_view.xml').read  
  end
  before(:each) do
    sign_in_developer
  end
  after(:each) do
    sign_out_developer
  end    
  scenario 'is on statistic page' do
    visit analytics_path
    expect(page).to have_selector('h3', :text => 'Media Analytics Overview')
    expect(@stat_new_courses).to have_content("12")
    expect(@stat_new_records).to have_content("6")
    doc = Nokogiri::XML::Document.parse(@stat_view)
    expect(doc).to have_content("3")
  end                                               
end