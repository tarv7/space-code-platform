# frozen_string_literal: true

class CreateShips < ActiveRecord::Migration[6.1]
  def change
    create_table :ships do |t|
      t.integer :fuel_capacity,   null: false
      t.integer :fuel_level,      null: false
      t.integer :weight_capacity, null: false
      t.references :pilot,        null: false, foreign_key: true

      t.timestamps
    end

    add_check_constraint :ships, 'fuel_capacity > 0', name: 'check_positive_fuel_capacity'
    add_check_constraint :ships, 'fuel_level >= 0', name: 'check_positive_fuel_level'
    add_check_constraint :ships, 'weight_capacity >= 0', name: 'check_positive_weight_capacity'
  end
end
