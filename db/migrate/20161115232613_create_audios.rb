class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.string :track
      t.string :album
      t.string :artist
      t.string :composer
      t.string :call_number
      t.string :year
      t.string :file_name

      t.timestamps null: false
    end
  end
end
