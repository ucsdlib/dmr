#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe Media do
  describe "GET /media" do
    it "works! (now write some real specs)" do
      get media_path
      expect(response).to have_http_status(302)
    end
  end
end
