
require 'rails_helper'

RSpec.describe Reports::TransactionSerializer do
  let(:pilot) { create(:pilot) }
  let(:planet) { create(:planet) }

  let(:contract_1) { create(:contract, :accepted) }
  let(:contract_2) { create(:contract, :accepted) }

  let!(:report_1) { create(:report, reportable: pilot, description: "#{pilot.name} bought fuel: +₭210", created_at: Date.today.ago(2.years)) }
  let!(:report_2) { create(:report, reportable: planet, description: "#{planet.name} receveid food: +₭210", created_at: Date.today.ago(4.years)) }
  let!(:report_3) { create(:report, reportable: contract_1, description: "#{contract_1.description} paid: +₭936", created_at: Date.today.ago(1.year)) }
  let!(:report_4) { create(:report, reportable: contract_2, description: "#{contract_2.description} paid: +₭1200", created_at: Date.today.ago(3.years)) }

  let(:expected) do
    [
      report_2.description,
      report_4.description,
      report_1.description,
      report_3.description
    ]
  end

  subject { described_class.new.serializable_hash }

  it { expect(subject).to match_array(expected) }
end