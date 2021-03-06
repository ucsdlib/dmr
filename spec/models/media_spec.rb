# encoding: utf-8
#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe Media, type: :model do
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:file_name)}
  it {should allow_value('anyFileName.mp4').for(:file_name)}
  it {should_not allow_value('noExtensionFilename').for(:file_name)}
  it {should have_many(:courses).through(:reports) }
  it {should allow_value('2017-01-01').for(:end_date)}
end
