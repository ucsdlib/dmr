#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe CoursesController do
  describe "GET index" do
    it "assigns all courses as @courses" do
      @course = Fabricate(:course)
      get :index 
      expect(Course.count).to eq(1)
      expect(assigns(:courses)).to eq([@course])
    end
  end

  describe "GET show" do
    it "assigns the requested course as @course" do
      @course = Fabricate(:course)
      get :show, {:id => @course.id}
      assigns(:course).should eq(@course)
      expect(assigns(:course)).to eq(@course)      
    end
  end

  describe "GET new" do
    it "assigns a new course as @course" do
      get :new
      expect(assigns(:course)).to be_a_new(Course)
    end
  end

  describe "GET edit" do
    it "assigns the requested course as @course" do
      @course = Fabricate(:course)
      get :edit, {:id => @course.id}
      expect(assigns(:course)).to eq(@course)
    end
  end

  describe "POST create" do      
    describe "with valid params" do
      before do
        post :create, course: Fabricate.attributes_for(:course)
      end    
      it "creates a new Course" do
        expect(Course.count).to eq(1)
      end

      it "assigns a newly created course as @course" do
        expect(assigns(:course)).to be_a(Course)
        expect(assigns(:course)).to be_persisted
      end

      it "redirects to the course index page" do
        expect(response).to redirect_to(edit_course_path(Course.last))
      end
    end

    describe "with invalid params" do
      before do
        post :create, course: {year: "abcd"}
      end    
      
      it "assigns a newly created but unsaved course as @course" do
        expect(assigns(:course)).to be_a_new(Course)
      end
      
      it "does not create a new Course" do
        expect(Course.count).to eq(0)
      end
      
      it "re-renders the 'new' template" do
        expect(response).to render_template :new
      end
    end
    
    describe "with has_many through association" do
      before do
        @media = Fabricate(:media)
        @media2 = Fabricate(:media)
        @course = Fabricate(:course)
      end    
      it "creates a new Course with 2 Media objects" do
        @course.reports.create(media: @media)
        @course.reports.create(media: @media2)
        expect(Course.count).to eq(1)   
        expect(Media.count).to eq(2)    
        expect(@course.media.size).to eq(2)
        expect(@course.reports.size).to eq(2) 
        expect(@course.media.map(&:title)).to include('Test Media')  
        expect(response.status).to eq( 200 )
      end
    end   
  end

  describe "PUT update" do
    describe "with valid params" do
      before(:each) do     
        @course = Fabricate(:course)        
        put :update, id: @course, course: Fabricate.attributes_for(:course, instructor: 'Test Instructor Update')
        @course.reload        
      end

      it "updates the requested course" do
        expect(@course.instructor).to eq('Test Instructor Update')
      end

      it "assigns the requested course as @course" do
        expect(assigns(:course)).to eq(@course)
      end

      it "redirects to the course" do
        expect(response).to redirect_to(edit_course_path(@course))
      end
    end

    describe "with invalid params" do
      before(:each) do
        @course = Fabricate(:course)        
        put :update, id: @course, course: Fabricate.attributes_for(:course, year: 'abcd')
        @course.reload                  
      end 
      
      it "does not update the requested course" do
        expect(@course.year).to eq('2015')
      end 
             
      it "assigns the course as @course" do
        expect(assigns(:course)).to eq(@course)
      end

      it "re-renders the 'edit' template" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @course = Fabricate(:course)
      @media = Fabricate(:media)
      @media2 = Fabricate(:media)
      @course.reports.create(media: @media)
      @course.reports.create(media: @media2)                    
      delete :destroy, id: @course
    end

    it "redirects to the courses list" do
      expect(response).to redirect_to courses_path
    end

    it "destroys the requested course" do
      expect(Course.count).to eq(0)
    end
    
    it "destroys the requested course reports" do
      expect(@course.reports.size).to eq(0)
    end
    
    it "does not destroy the requested course media objects" do
      expect(@course.media.size).to eq(0)
      expect(Media.count).to eq(2)
    end         
  end

  describe "GET set_current_course" do
    before(:each) do
      @course = Fabricate(:course)                
    end

    it "sets the last created course as current Course Reserve List automatically" do
      post :create, course: Fabricate.attributes_for(:course)  
      expect(session[:current_course].to_i).to eq(Course.last.id)
    end

    it "sets the first created course as current Course Reserve List" do
      get :set_current_course, id: @course.id  
      expect(session[:current_course].to_i).to eq(@course.id)
    end
  end
  
  describe "POST add_to_course" do
    before(:each) do
      @course = Fabricate(:course)
      @media = Fabricate(:media)
      @media2 = Fabricate(:media)
      @media3 = Fabricate(:media)
      get :set_current_course, id: @course.id                
    end
    
    it "adds a media object to the current Course Reserve List" do       
      post :add_to_course, media_ids: ["#{@media.id}"]             
      expect(session[:current_course].to_i).to eq(@course.id)
      expect(response).to redirect_to edit_course_path(@course)
      expect(@course.media.size).to eq(1) 
      expect(@course.media.map(&:title)).to include('Test Media')        
    end
    
    it "adds multiple media objects to the current Course Reserve List" do       
      post :add_to_course, media_ids: ["#{@media.id}","#{@media2.id}","#{@media3.id}"]            
      expect(session[:current_course].to_i).to eq(@course.id)
      expect(response).to redirect_to edit_course_path(@course)
      expect(@course.media.size).to eq(3) 
      expect(@course.media.map(&:title)).to include('Test Media')        
    end    
  end
  
  describe "GET search" do
    before(:each) do
      @course = Fabricate(:course)
    end
    
    it "returns Course objects if there is a match" do
      get :search, search: "Test", search_option: "courses"
      expect(assigns(:courses)).to eq([@course])
    end

    it "returns nil if there is no match" do
      get :search, search_term: "abcd", search_option: "courses"
      expect(assigns(:courses)).to eq(nil)
    end
    
    it "returns number of Course objects if there is a match" do
      get :search, search: "Test", search_option: "courses"
      expect(assigns(:course_search_count)).to eq(1)
    end    
  end     
end
