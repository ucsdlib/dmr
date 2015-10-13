# encoding: utf-8
#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe MediaHelper do
  describe '#Wowza URL' do
    it 'Builds Wowza URL' do
      @media = Fabricate(:media)
      expect(helper.grabWowzaURL(@media.file_name,@media.id)).to include "#{Rails.configuration.wowza_baseurl}"
    end
  end
end