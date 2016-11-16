require 'spec_helper'

describe AudiosHelper do
  describe '#Validate URL' do
    it 'Checks to see if URL exists' do
      existURL = "#{Rails.configuration.audio_file_path}pureAwareness.jpg"
      notExistURL = "#{Rails.configuration.audio_file_path}pureAwareness2.jpg"
      expect(helper.url_exist?(existURL)).to equal true
      expect(helper.url_exist?(notExistURL)).to equal false
    end
  end
end
