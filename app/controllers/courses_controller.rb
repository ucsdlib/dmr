#---
# @author Vivian <tchu@ucsd.edu>
#---

class CoursesController < ApplicationController
  include Dmr::ControllerHelper
  before_filter :authorize_student, only: [:show] if Rails.configuration.shibboleth
  before_filter :authorize, only: [:index, :create, :edit, :update, :new, :destroy, :search]

  before_action :set_course, only: [:show, :edit, :update, :destroy, :clone_course, :send_email]
  before_action :set_sorted_media, only: [:show, :edit, :send_email, :update]

  ##
  # Handles GET index request to display last 10 Courses from the database
  # GET /courses/index
  #
  # @return [String] the resulting webpage of the last 10 Course objects
  #
  def index
    @courses = Course.order('created_at DESC').limit(10)
  end

  ##
  # Handles GET show request to display the details of a single Course object
  # GET /courses/1
  #
  # @return [String] the resulting webpage of a single object
  #
  def show
    render layout: false
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
    remove_media_from_course(params[:media_ids],@course) if removing_item?
    change_media_order(params[:media_ids],@course,params[:commit])
    if @course.update_attributes(course_params)
      send_email
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
    redirect_to courses_path, notice: 'Course was successfully destroyed.'
  end

  ##
  # Handles GET search for Course object
  #
  def search
    if params[:search] && !params[:search].blank?
      @courses = Course.search(params[:search]).order(:course).page(params[:page]).per(20)
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
    if params[:id]
      session[:current_course] = params[:id]
      redirect_to edit_course_path(params[:id].to_s), notice: 'Current Course was successfully set.'
    end
  end

  ##
  # Clone a Course Reserve List object
  # /courses/clone_course?id=1
  #
  # @return [String] - redirect to the Course edit page
  #
  def clone_course
    new_course = @course.amoeba_dup
    redirect_to edit_course_path(new_course), notice: 'Course was successfully cloned.' if new_course.save!
  end

  ##
  # Handles POST a set of media ids to be added to the current Course object
  # POST /courses/add_to_course
  #
  # @return [String] - redirect to the Course edit page if successful
  #
  def add_to_course
    if deleting_media?
      delete_media(params[:media_ids])
      redirect_to media_path, notice: 'Selected Records were successfully deleted.' 
    elsif !session[:current_course].nil?
      add_media_to_course(params[:media_ids],session[:current_course])
      redirect_to edit_course_path(@course), notice: 'Media was successfully added to current Course.'
    else
      redirect_to courses_path, alert: 'No current Course is set.  Set the Course first.'
    end
  end

  ##
  # Handles GET send a confirmation email about the Course
  # GET /courses/send_mail
  #
  def send_email
    if send_list?
      CourseMailer.course_email(current_user, @course, @sorted_media).deliver_now
      redirect_to edit_course_path(@course), notice: 'The confirmation email has been sent.'
    else
      redirect_to edit_course_path(@course), notice: 'Course successfully updated.'
    end  
  end
         
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_sorted_media
    @sorted_media = get_sorted_media(@course)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_params
    params.require(:course).permit(:quarter, :year, :course, :instructor, media_ids: [])
  end

  def removing_item?
    params[:commit] == 'Remove Item(s)'
  end

  def send_list?
    params[:commit] == 'Send List'
  end
  
  def deleting_media?
    params[:commit] == 'Delete Selected Records'
  end          
end
