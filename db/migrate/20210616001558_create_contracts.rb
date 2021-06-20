# frozen_string_literal: true

class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.text :description
      t.references :payload,      null: false, foreign_key: { to_table: :resources }
      t.integer :payload_weight,  null: false
      t.references :origin,       null: false, foreign_key: { to_table: :planets }
      t.references :destiny,      null: false, foreign_key: { to_table: :planets }
      t.integer :value,           null: false
      t.references :pilot,        foreign_key: true
      t.string :state,            null: false

      t.timestamps
    end

    add_check_constraint :contracts, 'payload_weight >= 0', name: 'check_positive_payload_weight'
    add_check_constraint :contracts, 'value >= 0', name: 'check_positive_value'

    add_index :contracts, :state
  end
end
