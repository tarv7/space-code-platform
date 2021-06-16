require 'rails_helper'

RSpec.describe TravelRoute, type: :model do
  describe 'associations' do
    it { should belong_to(:origin) }
    it { should belong_to(:destiny) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:cost) }
    it { should validate_length_of(:cost).is_at_least(0) }
  end
end
