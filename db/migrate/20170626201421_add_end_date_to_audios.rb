class AddEndDateToAudios < ActiveRecord::Migration
  def change
    add_column :audios, :end_date, :string
  end
end
