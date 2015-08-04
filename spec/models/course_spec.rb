#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe Course do
  it {should validate_presence_of(:quarter)}
  it {should validate_presence_of(:instructor)}
  it {should validate_presence_of(:course)}
  it {should validate_length_of(:year)}
  it {should allow_value("2015").for(:year)}
  it {should_not allow_value("abcd").for(:year)}
  it {should have_many(:media).through(:reports) }
end