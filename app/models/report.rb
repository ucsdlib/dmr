class Report < ActiveRecord::Base
  belongs_to :course
  belongs_to :media
  validates :course_id, presence: true
  validates :media_id, presence: true  
end
