# encoding: utf-8
#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe Report, type: :model do
  it {should belong_to(:course) }
  it {should belong_to(:media) }
  it {should validate_presence_of(:course_id)}
  it {should validate_presence_of(:media_id)}
  it {should validate_presence_of(:counter)}  
end
