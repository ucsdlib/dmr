#---
# @author Vivian <tchu@ucsd.edu>
#---

class Media < ActiveRecord::Base
  has_many :reports, dependent: :delete_all
  has_many :courses, through: :reports
  validates :title, presence: true
  validates :call_number, presence: true
  validates :year, length: { maximum: 4 }, format: { :with => /\A\d{4}\z/, :message => "must be in number format" }
  validates :file_name, format: { :with => /\A\w+(\.mp4)\z/, :message => "must be in .mp4 format" }
  
  ##
  # Handles search request for Media object
  #
  # @param query [String] the search query
  # @return [String] the resulting Media objects whose titles contain one ore more words that form the query
  #
  def self.search(query)
    where("lower(title || director || year || call_number) like ?", "%#{query.downcase}%")
  end

end
