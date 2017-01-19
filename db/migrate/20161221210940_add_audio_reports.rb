class AddAudioReports < ActiveRecord::Migration
  def change
    create_table :audio_reports do |t|

      t.timestamps null: false
    end
    add_column :audio_reports, :course_id, :integer
    add_column :audio_reports, :audio_id, :integer
  end
end
