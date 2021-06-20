require 'rails_helper'

RSpec.describe Pilot, type: :model do
  subject { build(:pilot) }

  describe 'associations' do
    it { should belong_to(:location) }

    it { should have_many(:ships) }
    it { should have_many(:reports) }
  end

  describe 'validations' do
    it { should validate_presence_of(:certification) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_presence_of(:credits) }

    it { should validate_uniqueness_of(:certification).case_insensitive }
    it { should validate_length_of(:certification).is_equal_to(7) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(255) }
    it { should validate_length_of(:age).is_at_least(0) }
    it { should validate_length_of(:credits).is_at_least(0) }

    describe 'Check Certification in Luhn standard' do
      context 'when is valid' do
        it { expect(subject).to be_valid }
      end

      context 'when is invalid' do
        subject { build(:pilot, certification: '1234567') }

        it { expect(subject).to_not be_valid }
      end
    end
  end
end
