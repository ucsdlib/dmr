class AddColumnToReport < ActiveRecord::Migration
  def change
    add_column :reports, :course_id, :integer
    add_column :reports, :media_id, :integer
  end
end
