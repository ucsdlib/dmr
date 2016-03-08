require 'spec_helper'

describe AnalyticsController do
  before(:each) do
    set_current_user
  end
  describe 'GET index' do
    it "renders the 'index' template" do 
      expect(response.status).to eq( 200 )
    end
  end
end
