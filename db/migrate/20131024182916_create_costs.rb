class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.float :value
      t.integer :user_id
      t.integer :trip_id
      t.integer :exchange_id

      t.timestamps
    end
  end
end
