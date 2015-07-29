require 'spec_helper'

describe "media/show" do
  before(:each) do
    @media = Fabricate(:media)
  end

  it "renders attributes" do
    render
    rendered.should match(/Test Media/)
  end
end
