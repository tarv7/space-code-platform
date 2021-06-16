FactoryBot.define do
  factory :resource do
    sequence(:name) { |n| "#{['stone', 'water', 'fire'].sample} #{n}" }
  end
end