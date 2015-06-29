#---
# @author tchu@ucsd.edu
#---

class Media < ActiveRecord::Base
  validates :title, presence: true 
  validates :call_number, presence: true 
  validates :year, length: { maximum: 4 }
  validates :file_name, format: { :with => /\w(\.mp4)\z/, :message => "File name must be in .mp4 format" }
end
