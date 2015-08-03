class Report < ActiveRecord::Base
  belongs_to :course
  belongs_to :media
end
