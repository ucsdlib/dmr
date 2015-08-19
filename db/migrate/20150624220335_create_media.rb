class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :title
      t.string :director
      t.string :call_number
      t.string :year
      t.string :file_name

      t.timestamps null: false
    end
  end
end
