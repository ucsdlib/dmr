#---
# @author tchu@ucsd.edu
#---

class Media < ActiveRecord::Base
  validates :title, presence: true 
  validates :call_number, presence: true 
  validates :year, length: { maximum: 4 }
end
