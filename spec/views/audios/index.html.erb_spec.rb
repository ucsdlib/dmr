require 'spec_helper'

RSpec.describe "audios/index", type: :view do
  before(:all) do
    @audio1 = Audio.create track: 'Test Audio 1', year: '2016', call_number: '11111111', file_name: 'file.mp3'
    @audio2 = Audio.create track: 'Test Audio 2', year: '2016', call_number: '22222222', file_name: 'file.mp3'    
    assign(:audios, [@audio1,@audio2])
  end
  after(:all) do
    @audio1.delete
    @audio2.delete
  end

  it "renders a list of audios" do
    render
    assert_select "tr>td", :text => "Test Audio 1".to_s, :count => 1
    assert_select "tr>td", :text => "Test Audio 2".to_s, :count => 1
    assert_select "tr>td", :text => "11111111".to_s, :count => 1
    assert_select "tr>td", :text => "22222222".to_s, :count => 1
    assert_select "tr>td", :text => "2016".to_s, :count => 2
    assert_select "tr>td", :text => "file.mp3".to_s, :count => 2
  end
end
