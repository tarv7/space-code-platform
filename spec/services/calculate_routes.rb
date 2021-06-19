require 'rails_helper'

RSpec.describe CalculateRoutes, type: :model do
  let!(:andvari) { create(:planet, name: 'Andvari') }
  let!(:demeter) { create(:planet, name: 'Demeter') }
  let!(:aqua) { create(:planet, name: 'Aqua') }
  let!(:calas) { create(:planet, name: 'Calas') }

  let(:planets) { [andvari, demeter, aqua, calas].map(&:name) }

  before do
    create(:travel_route, origin: andvari, destiny: aqua, cost: 13)
    create(:travel_route, origin: andvari, destiny: calas, cost: 23)
    create(:travel_route, origin: demeter, destiny: aqua, cost: 22)
    create(:travel_route, origin: demeter, destiny: calas, cost: 25)
    create(:travel_route, origin: aqua, destiny: demeter, cost: 30)
    create(:travel_route, origin: aqua, destiny: calas, cost: 12 )
    create(:travel_route, origin: calas, destiny: andvari, cost: 20)
    create(:travel_route, origin: calas, destiny: demeter, cost: 25)
    create(:travel_route, origin: calas, destiny: aqua, cost: 15)
  end

  describe '#best_path' do
    let(:expected) do
      {
        { "Andvari" => "Aqua" } => { cost: 13, path: ["Andvari", "Aqua"] },
        { "Andvari" => "Calas" } => { cost: 23, path: ["Andvari", "Calas"] },
        { "Demeter" => "Aqua" } => { cost: 22, path: ["Demeter", "Aqua"] },
        { "Demeter" => "Calas" } => { cost: 25, path: ["Demeter", "Calas"] },
        { "Aqua" => "Demeter" } => { cost: 30, path: ["Aqua", "Demeter"] },
        { "Aqua" => "Calas" } => { cost: 12, path: ["Aqua", "Calas"] },
        { "Calas" => "Andvari" } => { cost: 20, path: ["Calas", "Andvari"] },
        { "Calas" => "Demeter" } => { cost: 25, path: ["Calas", "Demeter"] },
        { "Calas" => "Aqua" } => { cost: 15, path: ["Calas", "Aqua"] },
        { "Andvari" => "Andvari" } => { cost: 0, path: ["Andvari"] },
        { "Andvari" => "Demeter" } => { cost: 43, path: ["Andvari", "Aqua", "Demeter"] },
        { "Demeter" => "Andvari" } => { cost: 45, path: ["Demeter", "Calas", "Andvari"] },
        { "Demeter" => "Demeter" } => { cost: 0, path: ["Demeter"] },
        { "Aqua" => "Andvari" } => { cost: 32, path: ["Aqua", "Calas", "Andvari"] },
        { "Aqua" => "Aqua" } => { cost: 0, path: ["Aqua"] },
        { "Calas" => "Calas" } => { cost: 0, path: ["Calas"] }
      }
    end

    it 'match response' do
      planets.each do |origin|
        planets.each do |destiny|
          expect(described_class.best_path(origin: origin, destiny: destiny)).to match(expected[{ origin => destiny }])
        end
      end
    end
  end
end
