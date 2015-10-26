# encoding: utf-8
#
# @author Vivian <tchu@ucsd.edu>
#
class Report < ActiveRecord::Base
  belongs_to :course, dependent: :destroy
  belongs_to :media, dependent: :destroy
  validates :course_id, presence: true
  validates :media_id, presence: true
  validates :counter, presence: true

  ##
  # Enables copying
  #
  amoeba do
    enable
  end
end
