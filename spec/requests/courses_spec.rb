# encoding: utf-8
#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe Course do
  describe 'GET /courses' do
    it 'works! (now write some real specs)' do
      get courses_path
      expect(response).to have_http_status(302)
    end
  end
end
