
require 'rails_helper'

RSpec.describe Reports::ByPilotSerializer do
  let(:pilot_1) { create(:pilot, name: "Pilot 1") }
  let(:pilot_2) { create(:pilot, name: "Pilot 2") }
  let(:pilot_3) { create(:pilot, name: "Pilot 3") }
  let(:expected) do
    [
      {
        pilot_1.name.to_sym => {
          food: 32,
          minerals: 128,
          water: 8
        }
      },
      {
        pilot_2.name.to_sym => {
          minerals: 64,
          water: 512
        },
      },
      {
        pilot_3.name.to_sym => {
          food: 64,
          minerals: 64
        }
      }
    ]
  end

  let(:water) { create(:resource, name: 'water') }
  let(:food) { create(:resource, name: 'food') }
  let(:minerals) { create(:resource, name: 'minerals') }

  before do
    create_list(:contract, 8, :finished, pilot: pilot_1, payload: water, payload_weight: 1)
    create_list(:contract, 16, :finished, pilot: pilot_1, payload: food, payload_weight: 2)
    create_list(:contract, 32, :finished, pilot: pilot_1, payload: minerals, payload_weight: 4)
    create_list(:contract, 64, :finished, pilot: pilot_2, payload: water, payload_weight: 8)
    create_list(:contract, 4, :finished, pilot: pilot_2, payload: minerals, payload_weight: 16)
    create_list(:contract, 2, :finished, pilot: pilot_3, payload: food, payload_weight: 32)
    create_list(:contract, 1, :finished, pilot: pilot_3, payload: minerals, payload_weight: 64)
  end

  subject { described_class.new.serializable_hash }

  it { expect(subject).to match(expected) }
end