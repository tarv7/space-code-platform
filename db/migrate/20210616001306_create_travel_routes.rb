class CreateTravelRoutes < ActiveRecord::Migration[6.1]
  def change
    create_table :travel_routes do |t|
      t.references :origin,   null: false, foreign_key: { to_table: :planets }
      t.references :destiny,  null: false, foreign_key: { to_table: :planets }
      t.integer :cost,        null: false

      t.timestamps
    end

    add_check_constraint :travel_routes, 'cost > 0', name: 'check_positive_cost'

    add_index :travel_routes, [:origin_id, :destiny_id], unique: true
  end
end
