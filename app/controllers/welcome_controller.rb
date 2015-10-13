# encoding: utf-8
#---
# @author Vivian <tchu@ucsd.edu>
#---

class WelcomeController < ApplicationController
  layout 'application'
  ##
  # Handles GET index request
  #
  # @return [String] the resulting webpage
  def index
    @menu_display = 'false'
    @search_box_display = 'false'
    @menu_display = nil if logged_in?
  end

end
