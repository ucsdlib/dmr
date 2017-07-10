#
# @author Vivian <tchu@ucsd.edu>
#
class MediaController < ApplicationController
  include Dmr::ControllerHelper
  before_action :authorize, only: [:index, :show, :edit, :update, :new, :destroy,
                                   :search]
  before_action :set_media, only: [:show, :edit, :update, :destroy, :view]
  ##
  # Handles GET index request to display the last 10 Media from database
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
    render layout: false
  end

  ##
  # Handles GET show request to display the details of a single Media object
  # GET /view/1/filename
  #
  # @return [String] the resulting webpage of a single object
  #
  def view
    render layout: false
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
      redirect_to edit_medium_path(@media), notice: 'Video was successfully created.'
    else
      render :new
    end
  end

  ##
  # Handles GET edit a Media object
  #
  # @return [String] the resulting webpage with the Media object
  #
  def edit; end

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
      redirect_to edit_medium_path(@media), notice: 'Video successfully updated.'
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
    redirect_to media_path, notice: 'Video was successfully destroyed.'
  end

  ##
  # Handles GET search for Media object
  #
  def search
    return unless params[:search]
    if params[:search].blank?
      redirect_to root_path, alert: 'No text is inputted.'
    elsif params[:search].present?
      perform_search
      create_search_session
    end
  end

  private

  ##
  # Specify which parameters are allowed into Media controller actions to
  # prevent wrongful mass assignment.
  #
  # @!visibility private
  #
  def media_params
    params.require(:media).permit(:title, :director, :call_number, :year,
                                  :file_name, :end_date, course_ids: [])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_media
    @media = Media.find(params[:id])
  end

  def search_course_option?
    params[:search_option] == 'courses'
  end

  def search_audio_option?
    params[:search_option] == 'audio'
  end

  def create_search_session
    session[:search] = params[:search]
    session[:search_option] = params[:search_option] if params[:search_option]
  end

  def perform_search
    if search_course_option?
      redirect_to controller: 'courses', action: 'search',
                  search: params[:search], search_option: params[:search_option]
    elsif search_audio_option?
      redirect_to controller: 'audios', action: 'search',
                  search: params[:search], search_option: params[:search_option]
    else
      @media = full_search(params[:search], Media).order(:title).page(params[:page]).per(20)
      @search_count = @media.count
    end
  end
end
