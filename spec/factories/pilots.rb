FactoryBot.define do
  factory :pilot do
    certification { Luhn.generate(7) }
    name { Faker::Name.name }
    age { 20 }
    credits { 10 }

    association :location, factory: :planet

    transient do
      ships_count { 1 }
    end

    trait :with_ships do
      after :build do |pilot, evaluator|
        pilot.ships = build_list(:ship, evaluator.ships_count)
      end
    end
  end
end