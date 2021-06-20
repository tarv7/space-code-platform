# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResourceSerializer do
  let!(:resource) { create(:resource) }
  let(:expected) do
    {
      id: resource.id,
      name: resource.name
    }
  end

  subject { described_class.new(resource).serializable_hash }

  it { expect(subject).to match(expected) }
end
