class AddConstraintSamePlanetInContract < ActiveRecord::Migration[6.1]
  def up
    add_check_constraint :contracts, 'origin_id <> destiny_id', name: 'check_same_planets'
  end
end
