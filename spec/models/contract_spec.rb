require 'rails_helper'

RSpec.describe Contract, type: :model do
  describe 'associations' do
    it { should belong_to(:pilot) }
    it { should belong_to(:payload) }
    it { should belong_to(:origin) }
    it { should belong_to(:destiny) }
  end

  describe 'validations' do
    it { should validate_presence_of(:payload_weight) }
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:state) }

    it { should validate_length_of(:description).is_at_least(0).is_at_most(5000) }
    it { should validate_length_of(:payload_weight).is_at_least(0) }
    it { should validate_length_of(:value).is_at_least(0) }
  end
end