class CreateCheckin < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer :user_id

      t.timestamps
    end

    add_index :checkins, :user_id
  end
end
