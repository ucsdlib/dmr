class AddIndexToReports < ActiveRecord::Migration
  def change
    add_index :reports, :course_id
    add_index :reports, :media_id
  end
end
