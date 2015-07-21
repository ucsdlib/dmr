require 'spec_helper'

describe "media/show" do
  before(:each) do
    @media = Fabricate(:media)
  end

  it "renders attributes" do
    render
    rendered.should match(/Title/)
    rendered.should match(/Test Media/)
    rendered.should match(/Director/)
    rendered.should match(/Test Director/)
    rendered.should match(/Call Number/)
    rendered.should match(/bb77777777/)
    rendered.should match(/Year/)
    rendered.should match(/2015/)
    rendered.should match(/File Name/)
    rendered.should match(/test.mp4/)
  end
end
