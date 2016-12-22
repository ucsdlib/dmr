# encoding: utf-8
#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe Audioreport, type: :model do
  it {should belong_to(:course) }
  it {should belong_to(:audio) }
end
