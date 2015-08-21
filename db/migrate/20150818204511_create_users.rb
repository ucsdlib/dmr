class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name,		:null => true, :default => ""
      t.string :email, 		:null => true, :default => ""
      t.string :uid,		:null => false, :default => ""
      t.string :provider,	:null => false, :default => ""

      t.timestamps null: false
    end
    
    add_index :users, :email,                :unique => true
    add_index :users, :name,                :unique => true
    add_index :users, [:provider,:uid],      :unique => true    
  end
end
