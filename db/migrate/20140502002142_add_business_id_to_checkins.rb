class AddBusinessIdToCheckins < ActiveRecord::Migration
  def change
    add_column :checkins, :business_id, :integer
    add_index :checkins, :business_id
  end
end
