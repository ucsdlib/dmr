require 'spec_helper'

RSpec.describe "audios/new", type: :view do
  before(:each) do
    assign(:audio, Audio.new(
      :track => "MyString",
      :album => "MyString",
      :artist => "MyString",
      :composer => "MyString",
      :call_number => "MyString",
      :year => "2016",
      :file_name => "test.mp3"
    ))
  end

  it "renders new audio form" do
    render

    assert_select "form[action=?][method=?]", audios_path, "post" do

      assert_select "input#audio_track[name=?]", "audio[track]"

      assert_select "input#audio_album[name=?]", "audio[album]"

      assert_select "input#audio_artist[name=?]", "audio[artist]"

      assert_select "input#audio_composer[name=?]", "audio[composer]"

      assert_select "input#audio_call_number[name=?]", "audio[call_number]"

      assert_select "input#audio_year[name=?]", "audio[year]"

      assert_select "input#audio_file_name[name=?]", "audio[file_name]"
    end
  end
end
