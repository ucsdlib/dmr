#---
# @author Vivian <tchu@ucsd.edu>
#---

class Course < ActiveRecord::Base
  has_many :reports
  has_many :media, through: :reports
  validates :quarter, presence: true
  validates :year, presence: true, length: { maximum: 4 }, format: { :with => /\A\d+/, :message => "must be in number format" }
  validates :course, presence: true
  validates :instructor, presence: true
end
