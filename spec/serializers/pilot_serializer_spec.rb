
require 'rails_helper'

RSpec.describe PilotSerializer do
  let!(:pilot) { create(:pilot, :with_ship) }
  let(:expected) do
    {
      id: pilot.id,
      certification: pilot.certification,
      name: pilot.name,
      age: pilot.age,
      credits: pilot.credits,
      location: {
        id: pilot.location.id,
        name: pilot.location.name,
      },
      ship: {
        id: pilot.ship.id,
        fuel_capacity: pilot.ship.fuel_capacity,
        fuel_level: pilot.ship.fuel_level,
        weight_capacity: pilot.ship.weight_capacity
      }
    }
  end

  subject { described_class.new(pilot).serializable_hash }

  it { expect(subject).to match(expected) }
end