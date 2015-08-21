#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe ApplicationController do
  describe "#current_user" do
    it "returns the current_user name" do
      set_current_user
      expect(subject.current_user.name).to eq("developer")
    end
  end

  describe "#logged_in?" do
    it "returns true when the current_user exists" do
      set_current_user
      expect(subject.logged_in?).to eq(true)
    end
  end
  
  describe "#authorize" do
    it "returns true when the user logged_in" do
      set_current_user
      expect(subject.authorize).to eq(true)
    end
  end

  describe "#access_denied" do
    controller do
      def index
        access_denied
      end
    end  
    it "redirects to the login page" do
      get :index
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_user_session_path)
    end
  end  
end