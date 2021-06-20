require 'rails_helper'

RSpec.describe ShipSerializer do
  let!(:ship) { create(:ship) }
  let(:expected) do
    {
      id: ship.id,
      fuel_capacity: ship.fuel_capacity,
      fuel_level: ship.fuel_level,
      weight_capacity: ship.weight_capacity,
      pilot: {
        id: ship.pilot.id,
        certification: ship.pilot.certification,
        name: ship.pilot.name,
        age: ship.pilot.age,
        credits: ship.pilot.credits
      }
    }
  end

  subject { described_class.new(ship).serializable_hash }

  it { expect(subject).to match(expected) }
end
