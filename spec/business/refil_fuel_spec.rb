# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefilFuel, type: :model do
  let!(:ship) { create(:ship, fuel_level: 0) }

  describe '#call!' do
    subject { described_class.call!(ship: ship, fuel_quantity: quantity) }

    context 'when is successfully' do
      let(:quantity) { 1 }

      it 'should update field fuel_level and credits' do
        expect { subject }.
          to change { ship.reload.fuel_level }.from(0).to(1).
          and change { ship.pilot.reload.credits }.from(10).to(3).
          and change { ship.pilot.reload.reports.count }.by(1)
      end
    end

    context 'when is fail' do
      shared_examples 'should not update field fuel_level and credits' do |exception|
        it do
          expect { subject }.
            to raise_error(*exception).
            and change { ship.reload.fuel_level }.by(0).
            and change { ship.pilot.reload.credits }.by(0)
        end
      end

      context 'when the pilot doesn\'t have enough credits' do
        let(:quantity) { 300 }

        it_behaves_like 'should not update field fuel_level and credits',
                        [ActiveRecord::RecordInvalid, 'Validation failed: Credits must be greater than or equal to 0']
      end

      context 'when the gas tank is full' do
        let!(:ship) { create(:ship) }
        let(:quantity) { 1 }

        it_behaves_like 'should not update field fuel_level and credits',
                        [ActiveRecord::RecordInvalid, 'Validation failed: Fuel level must be less than or equal to 10']
      end

      context 'when the quantity is not positive' do
        let(:quantity) { -1 }

        it_behaves_like 'should not update field fuel_level and credits',
                        [RefilFuel::RefilFuelError, 'Amount of refill needs to be positive']
      end
    end
  end
end
