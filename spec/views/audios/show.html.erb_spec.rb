require 'spec_helper'

RSpec.describe "audios/show", type: :view do
  before(:each) do
    @audio = Fabricate(:audio)
  end
  
  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Test Track/)
  end
end
