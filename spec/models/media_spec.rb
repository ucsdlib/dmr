#---
# @author tchu@ucsd.edu
#---

require 'spec_helper'

describe Media do
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:call_number)}
  it {should validate_length_of(:year)}
  it {should allow_value("anyFileName.mp4").for(:file_name)}
  it {should_not allow_value("noExtensionFilename").for(:file_name)}
end
