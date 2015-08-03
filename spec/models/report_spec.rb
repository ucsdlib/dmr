#---
# @author Vivian <tchu@ucsd.edu>
#---

require 'spec_helper'

describe Report do
  it {should belong_to(:course) }
  it {should belong_to(:media) }
end
