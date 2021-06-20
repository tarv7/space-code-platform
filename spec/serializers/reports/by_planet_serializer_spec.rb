require 'rails_helper'

RSpec.describe Reports::ByPlanetSerializer do
  let(:pilot) { create(:pilot, location: planet_1) }
  let(:planet_1) { create(:planet, name: 'planet 1') }
  let(:planet_2) { create(:planet, name: 'planet 2') }
  let(:expected) do
    [
      {
        planet_1.name.to_sym => {
          sent: {
            food: 4,
            minerals: 2,
            water: 1
          },
          received: {
            minerals: 16,
            water: 8
          }
        }
      },
      {
        planet_2.name.to_sym => {
          sent: {
            water: 8,
            minerals: 16
          },
          received: {
            food: 4,
            minerals: 2,
            water: 1
          }
        }
      }
    ]
  end

  let(:water) { create(:resource, name: 'water') }
  let(:food) { create(:resource, name: 'food') }
  let(:minerals) { create(:resource, name: 'minerals') }

  before do
    create_list(:contract, 1, :finished, pilot: pilot, origin: planet_1, destiny: planet_2, payload: water,
                                         payload_weight: 1)
    create_list(:contract, 2, :finished, pilot: pilot, origin: planet_1, destiny: planet_2, payload: minerals,
                                         payload_weight: 1)
    create_list(:contract, 4, :finished, pilot: pilot, origin: planet_1, destiny: planet_2, payload: food,
                                         payload_weight: 1)
    create_list(:contract, 8, :finished, pilot: pilot, origin: planet_2, destiny: planet_1, payload: water,
                                         payload_weight: 1)
    create_list(:contract, 16, :finished, pilot: pilot, origin: planet_2, destiny: planet_1, payload: minerals,
                                          payload_weight: 1)
  end

  subject { described_class.new.serializable_hash }

  it { expect(subject).to match(expected) }
end
