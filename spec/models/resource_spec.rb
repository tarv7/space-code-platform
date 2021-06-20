# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(255) }
  end
end
