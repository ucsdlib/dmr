#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe WelcomeController do
  describe "GET index" do 
    it "renders the index page" do
      get :index 
      expect(response).to render_template :index
      expect(assigns(:menu_display)).to eq("false")
    end
  end
  
  describe "GET home" do 
    it "renders the home page" do
      get :home 
      expect(response).to render_template :home
      expect(assigns(:search_box_display)).to eq("false")
    end
  end  
end
