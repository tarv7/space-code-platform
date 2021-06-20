# frozen_string_literal: true

FactoryBot.define do
  factory :resource do
    sequence(:name) { |n| "#{%w[food water minerals].sample} #{n}" }
  end
end
