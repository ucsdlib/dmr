class RenameMyTable < ActiveRecord::Migration
  def change
    rename_table :audio_reports, :audioreports
  end
end
