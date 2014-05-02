class CreateBusiness < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :website
    end
  end
end
