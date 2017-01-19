#
# @author Vivian <tchu@ucsd.edu>
#
class Report < ActiveRecord::Base
  belongs_to :course, dependent: :destroy
  belongs_to :media, dependent: :destroy

  ##
  # Enables copying
  #
  amoeba do
    enable
  end
end
