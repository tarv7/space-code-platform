require 'rails_helper'

RSpec.describe PlanetSerializer do
  let!(:planet) { create(:planet) }
  let(:expected) do
    {
      id: planet.id,
      name: planet.name
    }
  end

  subject { described_class.new(planet).serializable_hash }

  it { expect(subject).to match(expected) }
end
