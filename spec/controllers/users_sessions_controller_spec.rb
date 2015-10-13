# encoding: utf-8
#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe Users::SessionsController do
  describe 'GET new' do
    it 'redirects to the user sign in page' do
      get :new
      response.should redirect_to(developer_path)
    end
  end

  describe 'GET developer' do
    it 'redirects to the home page' do
      get :developer
      flash[:notice].should include 'You have successfully authenticated from developer account!'
      response.should redirect_to(root_path)
    end
  end

  describe 'GET shibboleth' do
    it 'redirects to the home page' do
      get :shibboleth
      flash[:notice].should include 'You have successfully authenticated from shibboleth account!'
      response.should redirect_to(root_path)
    end
  end
    
  describe 'GET destroy' do
    it 'destroys user session' do
      get :destroy 
      session[:user_name].should eq(nil)
      session[:uid].should eq(nil)
    end
  end       
end
