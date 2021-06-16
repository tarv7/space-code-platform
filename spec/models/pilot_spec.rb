require 'rails_helper'

RSpec.describe Pilot, type: :model do
  describe 'associations' do
    it { should belong_to(:location) }
  end

  describe 'validations' do
    it { should validate_presence_of(:certification) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_presence_of(:credits) }

    it { should validate_length_of(:certification).is_equal_to(7) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(255) }
    it { should validate_length_of(:age).is_at_least(0) }
    it { should validate_length_of(:credits).is_at_least(0) }
  end
end
