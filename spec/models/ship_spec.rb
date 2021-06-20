# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ship, type: :model do
  describe 'associations' do
    it { should belong_to(:pilot) }
  end

  describe 'validations' do
    it { should validate_presence_of(:fuel_capacity) }
    it { should validate_presence_of(:fuel_level) }
    it { should validate_presence_of(:weight_capacity) }

    it { should validate_length_of(:fuel_capacity).is_at_least(0) }
    it { should validate_length_of(:fuel_level).is_at_least(0) }
    it { should validate_length_of(:weight_capacity).is_at_least(0) }
  end
end
