class CreateToken < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :value
      t.references :user, index: true

      t.timestamps
    end

    add_index :tokens, :value, unique: true
  end
end
