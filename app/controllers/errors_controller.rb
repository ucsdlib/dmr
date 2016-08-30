#
# @author Vivian <tchu@ucsd.edu>
#
class ErrorsController < ApplicationController
  ##
  # Handles error routing request
  #
  def routing
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end
end
