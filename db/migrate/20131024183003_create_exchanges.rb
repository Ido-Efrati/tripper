class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.float :rate
      t.string :type
      t.integer :trip_id

      t.timestamps
    end
  end
end
