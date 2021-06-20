# frozen_string_literal: true

class CreatePilots < ActiveRecord::Migration[6.1]
  def change
    create_table :pilots do |t|
      t.string :certification,  null: false, limit: 7
      t.string :name,           null: false
      t.integer :age,           null: false
      t.integer :credits,       null: false
      t.references :location,   null: false, foreign_key: { to_table: :planets }

      t.timestamps
    end

    add_check_constraint :pilots, 'age > 0', name: 'check_positive_age'
    add_check_constraint :pilots, 'credits >= 0', name: 'check_positive_credits'

    add_index :pilots, :certification, unique: true
  end
end
