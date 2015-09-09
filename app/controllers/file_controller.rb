#---
# @author Vivian <tchu@ucsd.edu>
#---

class FileController < ApplicationController
  include Dmr::FileControllerHelper
  
  ##
  # Handles GET show request
  #
  # @return [String] the resulting image
  #
  def show
    display_file(params[:id],params[:ds])
  end
  
end
