# frozen_string_literal: true

FactoryBot.define do
  factory :planet do
    sequence(:name) { |n| "planet #{n}" }
  end
end
