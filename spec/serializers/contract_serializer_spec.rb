
require 'rails_helper'

RSpec.describe ContractSerializer do
  let!(:contract) { create(:contract, :with_pilot) }
  let(:expected) do
    {
      id: contract.id,
      description: contract.description,
      value: contract.value,
      state: contract.state,
      pilot: {
        id: contract.pilot.id,
        certification: contract.pilot.certification,
        name: contract.pilot.name,
        age: contract.pilot.age,
        credits: contract.pilot.credits
      },
      payload: {
        id: contract.payload.id,
        name: contract.payload.name,
        weight: contract.payload_weight
      },
      origin: {
        id: contract.origin.id,
        name: contract.origin.name
      },
      destiny: {
        id: contract.destiny.id,
        name: contract.destiny.name
      }
    }
  end

  subject { described_class.new(contract).serializable_hash }

  it { expect(subject).to match(expected) }
end