class AddEndDateToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :end_date, :string
  end
end
