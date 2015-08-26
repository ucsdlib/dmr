class Report < ActiveRecord::Base
  belongs_to :course, :dependent => :destroy
  belongs_to :media, :dependent => :destroy
  validates :course_id, presence: true
  validates :media_id, presence: true
  
  ##
  # Enables copying
  #
  amoeba do
    enable
  end  
end
