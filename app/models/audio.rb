#
# @author Vivian <tchu@ucsd.edu>
#
class Audio < ActiveRecord::Base
  has_many :audioreports, dependent: :delete_all
  has_many :courses, through: :audioreports
  validates :track, presence: true
  validates :file_name, presence: true, format: { with: /\A.+(\.mp3)\z/, message: 'must be in mp3' }
  validates :year, length: { maximum: 4 },
                   format: { with: /\A\d{4}\z/, message: 'must be in number format' }

  ##
  # Enables copying
  #
  amoeba do
    enable
  end
end
