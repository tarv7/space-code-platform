require 'rails_helper'

RSpec.describe Contract, 'stateable' do
  let!(:pilot) { create(:pilot) }

  describe "#accept!" do
    let!(:contract) { create(:contract, :opened) }

    subject { contract.accept!(pilot) }

    context "when is successfully" do
      it 'field state change to accept' do
        expect { subject }.
          to change { contract.state }.from('opened').to('accepted').
          and change { contract.reports.count }.by(1).
          and change { pilot.reports.count }.by(1)
      end
    end

    context "when is fail" do
      shared_examples 'raise error and not change state' do |exception|
        it do
          expect { subject }.to raise_error(*exception)

          expect(contract.reload.state).to eq('opened')
        end
      end

      context 'when the contract already has a pilot' do
        before { contract.update(pilot: build(:pilot)) }

        it_behaves_like 'raise error and not change state', [Contract::EventError, "Contract already has a pilot. Event: opened to accepted"]
      end

      context 'when no receive a valid pilot' do
        subject { contract.accept!(contract) }

        it_behaves_like 'raise error and not change state', [Contract::EventError, "Missing pilot. Event: opened to accepted"]
      end
    end
  end

  describe "#process!" do
    let!(:contract) { create(:contract, :accepted, pilot: pilot) }

    subject { contract.process!([create(:planet).name, create(:planet).name]) }

    it 'field state change to processing' do
      expect { subject }.
        to change { contract.state }.from('accepted').to('processing').
        and change { contract.reports.count }.by(1)
    end
  end

  describe "#finish!" do
    let!(:contract) { create(:contract, :processing, pilot: pilot) }

    subject { contract.finish! }

    it 'field state change to finished' do
      expect { subject }.
        to change { contract.state }.from('processing').to('finished').
        and change { contract.reports.count }.by(2).
        and change { pilot.reports.count }.by(1)
    end
  end
end