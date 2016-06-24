# encoding: utf-8
#
# @author Vivian <tchu@ucsd.edu>
#
class Media < ActiveRecord::Base
  has_many :reports, dependent: :delete_all
  has_many :courses, through: :reports
  validates :title, presence: true
  validates :file_name, presence: true, format: { with: /\A.+(\.mp4)\z/, message: 'must be in mp4' }

  ##
  # Enables copying
  #
  amoeba do
    enable
  end
end
