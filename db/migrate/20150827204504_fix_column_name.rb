class FixColumnName < ActiveRecord::Migration
  def change
    change_table :reports do |t|
      t.rename :order, :counter
    end  
  end
end
