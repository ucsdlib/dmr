##
# @author tchu
#

class FileController < ApplicationController
  include Dmr::ControllerHelper
  
  ##
  # Handles GET show request
  #
  # @return [String] the resulting image
  #
  def show
    display_file(params[:id],params[:ds])
  end
  
end
