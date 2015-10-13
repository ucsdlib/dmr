# encoding: utf-8
#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe WelcomeController do
  describe 'GET index' do
    it 'renders the index page before Sign In' do
      get :index 
      expect(response).to render_template :index
      expect(assigns(:menu_display)).to eq('false')
    end
  end
end
