#---
# @author Vivian <tchu@ucsd.edu>
#---

class MediaController < ApplicationController
  before_action :set_media, only: [:show, :edit, :update, :destroy]
  ##
  # Handles GET index request to display the last 10 Media objects from the database
  #
  # @return [String] the resulting webpage of the last 10 Media objects
  #
  def index
    @media = Media.order('created_at DESC').limit(10)
  end

  ##
  # Handles GET show request to display the details of a single Media object
  #
  # @return [String] the resulting webpage of a single object
  #
  def show
    render :layout => false
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
      redirect_to edit_medium_path(@media), notice: 'Media was successfully created.'
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
    @media.destroy 
    redirect_to media_path, :flash => { :notice => "Media was successfully destroyed." }
  end
 
  ##
  # Handles GET search for Media object
  #
  def search
    if params[:search] && !params[:search].blank? 
      session[:search] = params[:search]    
      session[:search_option] = params[:search_option] if params[:search_option]
      if(params[:search_option] && params[:search_option].include?("courses"))
        redirect_to :controller => 'courses', :action => 'search', :search => params[:search], :search_option => params[:search_option]
      else
        @media = Media.search(params[:search]).order(:title).page(params[:page]).per(10)
        @search_count = @media.count
      end
    end
  end
           
  private
    ##
    # Specify which parameters are allowed into Media controller actions to prevent wrongful mass assignment.
    #
    # @!visibility private
    #  
    def media_params
      params.require(:media).permit(:title, :director, :call_number, :year, :file_name, course_ids: [])
    end

    ##
    # Specify which Reports parameters are allowed into Media controller actions to prevent wrongful mass assignment.
    #
    # @!visibility private
    # 
    #def reports_params
    #  params.require(:report).permit(:course_id)
    #end

    # Use callbacks to share common setup or constraints between actions.
    def set_media
      @media = Media.find(params[:id])
    end        
end
