require 'rails_helper'

RSpec.describe Contract, 'stateable' do
  describe "#accept!" do
    let!(:contract) { create(:contract, :opened) }
    let!(:pilot) { create(:pilot) }

    subject { contract.accept!(pilot) }

    context "when is successfully" do
      it 'field state change to accept' do
        expect { subject }.to change { contract.state }.from('opened').to('accepted')
      end
    end

    context "when is fail" do
      shared_examples 'raise error and not change state' do
        it do
          expect { subject }.to raise_error

          expect(contract.reload.state).to eq('opened')
        end
      end
      
      context 'field state change to accept' do
        before { contract.update(pilot: build(:pilot)) }

        it_behaves_like 'raise error and not change state'
      end

      context 'field state change to accept' do
        before { allow_any_instance_of(Pilot).to receive(:blank?).and_return(true) }

        it_behaves_like 'raise error and not change state'
      end
    end
  end
end