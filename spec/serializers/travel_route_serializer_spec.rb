# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TravelRouteSerializer do
  let!(:planet_1) { create(:planet) }
  let!(:planet_2) { create(:planet) }
  let!(:planet_3) { create(:planet) }

  before do
    create(:travel_route, origin: planet_1, destiny: planet_2, cost: 1)
    create(:travel_route, origin: planet_2, destiny: planet_3, cost: 2)
    create(:travel_route, origin: planet_3, destiny: planet_2, cost: 8)
  end

  let(:expected) do
    [
      { origin: planet_1.name, destiny: planet_2.name, cost: 1, path: [planet_1.name, planet_2.name] },
      { origin: planet_1.name, destiny: planet_3.name, cost: 3, path: [planet_1.name, planet_2.name, planet_3.name] },
      { origin: planet_2.name, destiny: planet_3.name, cost: 2, path: [planet_2.name, planet_3.name] },
      { origin: planet_3.name, destiny: planet_2.name, cost: 8, path: [planet_3.name, planet_2.name] }
    ]
  end

  subject { described_class.new.serializable_hash }

  it { expect(subject).to match_array(expected) }
end
