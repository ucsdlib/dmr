class AddOrderToReports < ActiveRecord::Migration
  def change
    add_column :reports, :order, :string
  end
end
