class AddIndexToAudioReports < ActiveRecord::Migration
  def change
    add_index :audio_reports, :course_id
    add_index :audio_reports, :audio_id  
  end
end
