#---
# @author Vivian <tchu@ucsd.edu>
#---

class CoursesController < ApplicationController
  include Dmr::ControllerHelper
  before_filter :authorize_student, only: [:show] if Rails.configuration.shibboleth
  before_filter :authorize
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  
  ##
  # Handles GET index request to display the last 10 Course objects from the database
  # GET /courses/index  
  #
  # @return [String] the resulting webpage of the last 10 Course objects
  #
  def index
    @courses = Course.all
  end

  ##
  # Handles GET show request to display the details of a single Course object
  # GET /courses/1
  #
  # @return [String] the resulting webpage of a single object
  #
  def show
    render :layout => false
  end

  ##
  # Handles GET new request to a new Course object
  # GET /courses/new
  #
  # @return [String] for creating a new Course
  #
  def new
    @course = Course.new
  end

  ##
  # Handles POST create a Course object
  # POST /courses
  #
  # @note if successful
  # @return [String] - redirect to the resulting webpage of all Course objects
  # @note if failure
  # @return [String] the new Course form
  #  
  def create
    @course = Course.new(course_params)

    if @course.save  
      session[:current_course] = "#{@course.id}"
      redirect_to edit_course_path(@course), notice: 'Course was successfully created.'
    else
      render :new
    end
 
  end

  ##
  # Handles GET edit a Course object
  # GET /courses/1/edit
  #
  # @return [String] the resulting webpage with the Course object
  #    
  def edit
  end

  ##
  # Handles PUT update a Course object  
  # PATCH/PUT /courses/1
  #
  # @note if successful
  # @return [String] - redirect to the resulting webpage
  # @note if failure
  # @return [String] the edit Course form
  #  
  def update
    remove_media_from_course(params[:media_ids],params[:id]) if removing_item?
    if @course.update_attributes(course_params)
      redirect_to edit_course_path(@course), :flash => { :notice => "Course successfully updated." }
    else
      render :edit
    end
  end

  ##
  # Handles GET delete a Course object
  # DELETE /courses/1
  #
  # @return [String] - redirect to the Object index page
  #  
  def destroy
    @course.destroy
    redirect_to courses_path, :flash => { :notice => "Course was successfully destroyed." }
  end

  ##
  # Handles GET search for Course object
  #
  def search
    if params[:search] && !params[:search].blank?
      @courses = Course.search(params[:search]).order(:course).page(params[:page]).per(10)
      @course_search_count = @courses.count
      session[:search] = params[:search]
      session[:search_option] = params[:search_option] if params[:search_option]
    end
  end
  
  ##
  # Handles set a current Course object
  # /courses/set_current_course?id=1
  #
  # @return [String] - redirect to the Course edit page
  # 
  def set_current_course
    if (params[:id])
      session[:current_course] = params[:id]
      redirect_to edit_course_path(params[:id].to_s), :flash => { :notice => "Current Course Reserve List was successfully set." }
    end
  end

  ##
  # Handles POST a set of media ids to be added to the current Course object
  # POST /courses/add_to_course
  #
  # @return [String] - redirect to the Course edit page if successful
  #   
  def add_to_course
    if(session[:current_course] != nil)
      add_media_to_course(params[:media_ids],session[:current_course])
      redirect_to edit_course_path(@course), :flash => { :notice => "Media was successfully added to the current Course Reserve List." }
    else
      redirect_to courses_path, :flash => { :notice => "No current Course Reserve List is set.  Please set the Course Reserve List first." }
    end
  end
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:quarter, :year, :course, :instructor, media_ids: [])
    end
   
    def removing_item?
      params[:commit] == "Remove Item(s)"
    end
    
end
