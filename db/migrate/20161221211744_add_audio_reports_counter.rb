class AddAudioReportsCounter < ActiveRecord::Migration
  def change
    add_column :audio_reports, :counter, :string
  end
end
