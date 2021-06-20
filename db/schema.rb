# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_617_035_112) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'contracts', force: :cascade do |t|
    t.text 'description'
    t.bigint 'payload_id', null: false
    t.integer 'payload_weight', null: false
    t.bigint 'origin_id', null: false
    t.bigint 'destiny_id', null: false
    t.integer 'value', null: false
    t.bigint 'pilot_id'
    t.string 'state', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['destiny_id'], name: 'index_contracts_on_destiny_id'
    t.index ['origin_id'], name: 'index_contracts_on_origin_id'
    t.index ['payload_id'], name: 'index_contracts_on_payload_id'
    t.index ['pilot_id'], name: 'index_contracts_on_pilot_id'
    t.index ['state'], name: 'index_contracts_on_state'
    t.check_constraint 'payload_weight >= 0', name: 'check_positive_payload_weight'
    t.check_constraint 'value >= 0', name: 'check_positive_value'
  end

  create_table 'pilots', force: :cascade do |t|
    t.string 'certification', limit: 7, null: false
    t.string 'name', null: false
    t.integer 'age', null: false
    t.integer 'credits', null: false
    t.bigint 'location_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['certification'], name: 'index_pilots_on_certification', unique: true
    t.index ['location_id'], name: 'index_pilots_on_location_id'
    t.check_constraint 'age > 0', name: 'check_positive_age'
    t.check_constraint 'credits >= 0', name: 'check_positive_credits'
  end

  create_table 'planets', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'reports', force: :cascade do |t|
    t.string 'reportable_type', null: false
    t.bigint 'reportable_id', null: false
    t.text 'description', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[reportable_type reportable_id], name: 'index_reports_on_reportable'
  end

  create_table 'resources', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'ships', force: :cascade do |t|
    t.integer 'fuel_capacity', null: false
    t.integer 'fuel_level', null: false
    t.integer 'weight_capacity', null: false
    t.bigint 'pilot_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['pilot_id'], name: 'index_ships_on_pilot_id'
    t.check_constraint 'fuel_capacity > 0', name: 'check_positive_fuel_capacity'
    t.check_constraint 'fuel_level >= 0', name: 'check_positive_fuel_level'
    t.check_constraint 'weight_capacity >= 0', name: 'check_positive_weight_capacity'
  end

  create_table 'travel_routes', force: :cascade do |t|
    t.bigint 'origin_id', null: false
    t.bigint 'destiny_id', null: false
    t.integer 'cost', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['destiny_id'], name: 'index_travel_routes_on_destiny_id'
    t.index %w[origin_id destiny_id], name: 'index_travel_routes_on_origin_id_and_destiny_id', unique: true
    t.index ['origin_id'], name: 'index_travel_routes_on_origin_id'
    t.check_constraint 'cost > 0', name: 'check_positive_cost'
  end

  add_foreign_key 'contracts', 'pilots'
  add_foreign_key 'contracts', 'planets', column: 'destiny_id'
  add_foreign_key 'contracts', 'planets', column: 'origin_id'
  add_foreign_key 'contracts', 'resources', column: 'payload_id'
  add_foreign_key 'pilots', 'planets', column: 'location_id'
  add_foreign_key 'ships', 'pilots'
  add_foreign_key 'travel_routes', 'planets', column: 'destiny_id'
  add_foreign_key 'travel_routes', 'planets', column: 'origin_id'
end
