#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe MediaController do
   describe "GET index" do 
    it "get the count" do
      @media = Fabricate(:media)
      get :index 
      expect(Media.count).to eq(1)
    end
  end

  describe "GET show" do
    it "assigns the requested page as @media" do
      @media = Fabricate(:media)
      get :show, {:id => @media.id}
      assigns(:media).should eq(@media)
    end
  end 
    
  describe "GET new" do
    it "assigns a new Media as @media" do
      get :new
      assigns(:media).should be_a_new(Media)
    end
  end
  
  describe "POST create" do   
    describe "with valid params" do
      before do
        post :create, media: Fabricate.attributes_for(:media)
      end
          
      it "creates a new Media" do
        expect(Media.count).to eq(1)
      end
  
      it "assigns a newly created media as @media" do
        assigns(:media).should be_a(Media)
        assigns(:media).should be_persisted
      end
  
      it "redirects to the Media index page" do
        response.should redirect_to(media_url)
      end       
    end
    
    describe "with invalid params" do
      before do
        post :create, media: {year: "abcd"}
      end
          
      it "assigns a newly created media as @media" do
        assigns(:media).should be_a(Media)
      end

      it "does not create a new Media" do
        expect(Media.count).to eq(0)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end
    end
    
    describe "with has_many through association" do
      before do
        @media = Fabricate(:media)
        @course = Fabricate(:course)
        @course2 = Fabricate(:course)
      end    
      it "creates a new Media with 2 Course objects" do
        @media.reports.create(course: @course)
        @media.reports.create(course: @course2)
        expect(Media.count).to eq(1) 
        expect(Course.count).to eq(2)       
        expect(@media.courses.size).to eq(2)
        expect(@media.reports.size).to eq(2) 
        expect(@media.courses.map(&:course)).to include('Test Course')  
        expect(response.status).to eq( 200 )
      end
    end         
  end
 
  describe "GET edit" do
    it "assigns the requested page as @media" do
      @media = Fabricate(:media)
      get :edit, {:id => @media.id}
      assigns(:media).should eq(@media)
    end
  end

  describe "PUT update" do
    describe "with valid params" do   
      before(:each) do     
        @media = Fabricate(:media)        
        put :update, id: @media, media: Fabricate.attributes_for(:media, title: 'Test Media Update')
        @media.reload        
      end
      
      it "updates the requested media page" do
        expect(@media.title).to eq('Test Media Update')
      end
  
      it "assigns the requested page as @media" do
          assigns(:media).should eq(@media)
      end
  
      it "redirects to the media page" do
          response.should redirect_to(edit_medium_path(@media))
      end
    end

    describe "with invalid params" do   
      before(:each) do     
        @media = Fabricate(:media)        
        put :update, id: @media, media: Fabricate.attributes_for(:media, year: 'abcde')
        @media.reload        
      end
      
      it "does not update the requested media page" do
        expect(@media.year).to eq('2015')
      end
  
      it "assigns the requested page as @media" do
          assigns(:media).should eq(@media)
      end
  
      it "renders edit page" do
          expect(response).to render_template :edit
      end
    end
    
  end
  
  describe "DELETE destroy" do
    before(:each) do
      @media = Fabricate(:media) 
      @course = Fabricate(:course)
      @course2 = Fabricate(:course)
      @media.reports.create(course: @course)
      @media.reports.create(course: @course2)      
      delete :destroy, id: @media
    end

    it "redirects to the media index page" do
      expect(response).to redirect_to media_path
    end

    it "deletes the media" do
      expect(Media.count).to eq(0)
    end
    
    it "destroys the requested media reports" do
      expect(@media.reports.size).to eq(0)
    end
    
    it "does not destroy the requested media course objects" do
      expect(@media.courses.size).to eq(0)
      expect(Course.count).to eq(2)
    end    
  end
  
  describe "GET search" do
    before(:each) do
      @media = Fabricate(:media) 
    end
    
    it "returns Media objects if there is a match" do
      get :search, search: "Test", search_option: "media"
      expect(assigns(:media)).to eq([@media])
    end

    it "returns nil if there is no match" do
      get :search, search_term: "abcd", search_option: "media"
      expect(assigns(:media)).to eq(nil)
    end
    
    it "returns number of Media objects if there is a match" do
      get :search, search: "Test", search_option: "media"
      expect(assigns(:search_count)).to eq(1)
    end    
  end        
end
