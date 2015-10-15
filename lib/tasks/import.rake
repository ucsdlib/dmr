# encoding: utf-8
# bundle exec rake import
# This task import data from csv to create media records
require 'csv'
desc 'Imports a CSV file into an ActiveRecord table'
task :import, [:filename] => :environment do
  CSV.foreach('DMR_Data.csv', headers: true, encoding: 'ISO-8859-1') do |row|
    Media.create!(row.to_hash)
  end
end
