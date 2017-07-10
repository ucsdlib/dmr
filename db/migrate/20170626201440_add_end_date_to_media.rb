class AddEndDateToMedia < ActiveRecord::Migration
  def change
    add_column :media, :end_date, :string
  end
end
