FactoryBot.define do
  factory :travel_route do
    cost { 10 }

    association :origin, factory: :planet
    association :destiny, factory: :planet
  end
end
