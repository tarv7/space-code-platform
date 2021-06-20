require 'rails_helper'

RSpec.describe PilotSerializer do
  let!(:pilot) { create(:pilot_with_ships) }
  let(:expected) do
    {
      id: pilot.id,
      certification: pilot.certification,
      name: pilot.name,
      age: pilot.age,
      credits: pilot.credits,
      location: {
        id: pilot.location.id,
        name: pilot.location.name
      },
      ships: [
        {
          id: pilot.ships.first.id,
          fuel_capacity: pilot.ships.first.fuel_capacity,
          fuel_level: pilot.ships.first.fuel_level,
          weight_capacity: pilot.ships.first.weight_capacity
        }
      ]
    }
  end

  subject { described_class.new(pilot).serializable_hash }

  it { expect(subject).to match(expected) }
end
