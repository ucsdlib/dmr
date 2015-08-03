class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :quarter
      t.string :year
      t.string :course
      t.string :instructor

      t.timestamps null: false
    end
  end
end
