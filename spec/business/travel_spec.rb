require 'rails_helper'

RSpec.describe Travel, type: :model do
  let!(:planet_1) { create(:planet) }
  let!(:planet_2) { create(:planet) }
  let!(:planet_3) { create(:planet) }

  let(:ship) { pilot.ships.first }

  before do
    create(:travel_route, origin: planet_1, destiny: planet_2, cost: 1)
    create(:travel_route, origin: planet_2, destiny: planet_3, cost: 2)
    create(:travel_route, origin: planet_3, destiny: planet_2, cost: 4)
  end

  describe '#call!' do
    let(:pilot) { create(:pilot_with_ships, location: planet_1) }
    let!(:contract) { create(:contract, :accepted, pilot: pilot, origin: planet_3, destiny: planet_2) }

    subject { described_class.new(contract: contract, ship_id: ship.id).call! }

    before { ship.update(weight_capacity: 1000, fuel_capacity: 1000, fuel_level: 1000) }

    context "when is successfully" do
      it 'should update fields and contract trasit of state' do
        old_credits = pilot.credits
        old_fuel = ship.fuel_level

        subject

        expect(contract.state).to eq("finished")
        expect(pilot.location.name).to eq(contract.destiny.name)
        expect(pilot.credits).to eq(old_credits + contract.value)
        expect(ship.reload.fuel_level).to eq(old_fuel - 7)
      end
    end

    context "when is fail" do
      shared_examples 'raise exception and keep contract in accepted state' do |exception|
        it do
          expect { subject }.to raise_error(*exception)

          expect(contract.reload.state).to eq("accepted")
        end
      end

      context "when there is no route between origin and destination" do
        let(:pilot) { create(:pilot_with_ships, location: planet_3) }
        let!(:contract) { create(:contract, :accepted, pilot: pilot, origin: planet_2, destiny: planet_1) }

        it_behaves_like 'raise exception and keep contract in accepted state', [Travel::TravelError, 'There is no route between origin and destination']
      end

      context "when the gas level is below cost" do
        let(:pilot) { create(:pilot_with_ships, location: planet_1) }
        let!(:contract) { create(:contract, :accepted, pilot: pilot, origin: planet_1, destiny: planet_2) }

        before { ship.update(fuel_level: 0) }

        it_behaves_like 'raise exception and keep contract in accepted state', [Travel::TravelError, 'Fuel level is low']
      end

      context "when the ship cannot support the payload" do
        let(:pilot) { create(:pilot_with_ships, location: planet_1) }
        let!(:contract) { create(:contract, :accepted, pilot: pilot, origin: planet_1, destiny: planet_2) }

        before { ship.update(weight_capacity: 0) }

        it_behaves_like 'raise exception and keep contract in accepted state', [Travel::TravelError, 'Payload weight is greater than ship capacity']
      end

      context "when the ship belongs to another pilot" do
        let(:pilot) { create(:pilot_with_ships, location: planet_1) }
        let!(:contract) { create(:contract, :accepted, pilot: pilot, origin: planet_1, destiny: planet_2) }

        subject { described_class.new(contract: contract, ship_id: -1).call! }

        it_behaves_like 'raise exception and keep contract in accepted state', [ActiveRecord::RecordNotFound]
      end

      context "when raise exceptions in the middle of the travel" do
        before { expect_any_instance_of(Ship).to receive(:update!).and_raise(StandardError) }

        it_behaves_like 'raise exception and keep contract in accepted state', [StandardError, "StandardError"]
      end
    end
  end
end
