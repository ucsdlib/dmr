# encoding: utf-8
#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe AudiosController do
  before(:each) do
    @user = Fabricate(:user)
    set_current_user(@user)
  end

  describe "GET #index" do
    it 'get the count' do
      @audio = Fabricate(:audio)
      get :index 
      expect(Audio.count).to eq(1)
      expect(assigns(:audios)).to eq([@audio])
    end
  end

  describe "GET #show" do
    it "assigns the requested audio as @audio" do
      @audio = Fabricate(:audio)
      get :show, {:id => @audio.id}
      assigns(:audio).should eq(@audio)
    end
  end

  describe "GET #new" do
    it "assigns a new audio as @audio" do
      get :new
      expect(assigns(:audio)).to be_a_new(Audio)
    end
  end

  describe "GET #edit" do
    it "assigns the requested audio as @audio" do
      @audio = Fabricate(:audio)
      get :edit, {:id => @audio.id}      
      expect(assigns(:audio)).to eq(@audio)
    end
  end

  describe "POST #create" do
    describe 'with valid params' do
      before do
        post :create, audio: Fabricate.attributes_for(:audio)
      end
          
      it 'creates a new Audio' do
        expect(Audio.count).to eq(1)
      end
  
      it 'assigns a newly created audio as @audio' do
        assigns(:audio).should be_a(Audio)
        assigns(:audio).should be_persisted
      end
  
      it 'redirects to the Audio index page' do
        response.should redirect_to(edit_audio_path(Audio.last))
      end       
    end
    
    describe 'with invalid params' do
      before do
        post :create, audio: {year: 'abcd'}
      end
          
      it 'assigns a newly created audio as @audio' do
        assigns(:audio).should be_a(Audio)
      end

      it 'does not create a new Audio' do
        expect(Audio.count).to eq(0)
      end

      it 'render the :new template' do
        expect(response).to render_template :new
      end
    end
  end

  describe "PUT #update" do
    describe 'with valid params' do   
      before(:each) do     
        @audio = Fabricate(:audio)        
        put :update, id: @audio, audio: Fabricate.attributes_for(:audio, track: 'Test Audio Update')
        @audio.reload        
      end
      
      it 'updates the requested audio page' do
        expect(@audio.track).to eq('Test Audio Update')
      end
  
      it 'assigns the requested page as @audio' do
          assigns(:audio).should eq(@audio)
      end
  
      it 'redirects to the audio page' do
          response.should redirect_to(edit_audio_path(@audio))
      end
    end

    describe 'with invalid params' do   
      before(:each) do     
        @audio = Fabricate(:audio)        
        put :update, id: @audio, audio: Fabricate.attributes_for(:audio, file_name: 'abcde')
        @audio.reload        
      end
      
      it 'does not update the requested audio page' do
        expect(@audio.file_name).to eq('pureAwareness.mp3')
      end
  
      it 'assigns the requested page as @audio' do
          assigns(:audio).should eq(@audio)
      end
  
      it 'renders edit page' do
          expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested audio" do
      @audio = Fabricate(:audio)
      expect {
        delete :destroy, id: @audio
      }.to change(Audio, :count).by(-1)
    end

    it "redirects to the audios list" do
      @audio = Fabricate(:audio)
      delete :destroy, id: @audio
      expect(response).to redirect_to(audios_url)
    end
  end

end
