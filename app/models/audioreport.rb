#
# @author Vivian <tchu@ucsd.edu>
#
class Audioreport < ActiveRecord::Base
  belongs_to :course, dependent: :destroy
  belongs_to :audio, dependent: :destroy

  ##
  # Enables copying
  #
  amoeba do
    enable
  end
end
