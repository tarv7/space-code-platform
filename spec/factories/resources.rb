FactoryBot.define do
  factory :resource do
    sequence(:name) { |n| "#{['food', 'water', 'minerals'].sample} #{n}" }
  end
end