##
# @author tchu
#

class MediaController < ApplicationController
  ##
  # Handles GET index request to display all Media objects from the database
  #
  # @return [String] the resulting webpage of all Media objects
  #
  def index
    @medias = Media.last(20)
  end

  ##
  # Handles GET show request to display the details of a single Media object
  #
  # @return [String] the resulting webpage of a single object
  #
  def show
    @media = Media.find(params[:id])
  end

  ##
  # Handles GET new request to a new Media object
  #
  # @return [String] for creating a new Media
  #
  def new
    @media = Media.new
  end

  ##
  # Handles POST create a Media object
  #
  # @note if successful
  # @return [String] - redirect to the resulting webpage of all Media objects
  # @note if failure
  # @return [String] the new Media form
  #
  def create
    @media = Media.new(media_params)
    if @media.save
      redirect_to media_path, notice: 'Media was successfully created.'
    else
      render :new
    end
  end

  ##
  # Handles GET edit a Media object
  #
  # @return [String] the resulting webpage with the Media object
  #  
  def edit 
    @media = Media.find(params[:id]) 
  end

  ##
  # Handles PUT update a Media object
  #
  # @note if successful
  # @return [String] - redirect to the resulting webpage
  # @note if failure
  # @return [String] the edit Media form
  #
  def update 
    @media = Media.find(params[:id])
    if @media.update_attributes(media_params) 
      redirect_to edit_medium_path(@media), :flash => { :notice => "Media successfully updated." }
    else
      render :edit
    end   
  end

  ##
  # Handles GET delete a Media object
  #
  # @return [String] - redirect to the Media index page
  #
  def destroy
    media = Media.find(params[:id])
    media.destroy 
    redirect_to media_path, :flash => { :notice => "Media was successfully destroyed." }
  end
         
  private
    ##
    # Specify which parameters are allowed into Media controller actions to prevent wrongful mass assignment.
    #
    # @!visibility private
    #  
    def media_params
      params.require(:media).permit(:title, :director, :call_number, :year, :file_name)
    end
  
end
