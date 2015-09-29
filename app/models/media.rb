#---
# @author Vivian <tchu@ucsd.edu>
#---

class Media < ActiveRecord::Base
  has_many :reports, dependent: :delete_all
  has_many :courses, through: :reports
  validates :title, presence: true
  validates :file_name, presence: true, format: { :with => /\A.+(\.mp4)\z/, :message => "must be in .mp4 format" }

  ##
  # Enables copying
  #
  amoeba do
    enable
  end
    
  ##
  # Handles search request for Media object
  #
  # @param query [String] the search query
  # @return [String] the resulting Media objects whose titles contain one ore more words that form the query
  #
  def self.search(query)
    where("lower(title || director || year || call_number || file_name) like ?", "%#{query.downcase}%") if query
  end

end
