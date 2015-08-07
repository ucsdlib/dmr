#---
# @author Vivian <tchu@ucsd.edu>
#---

class CoursesController < ApplicationController
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:quarter, :year, :course, :instructor, media_ids: [])
    end
   
end
