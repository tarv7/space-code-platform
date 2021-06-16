FactoryBot.define do
  factory :contract do
    description { Faker::Lorem.paragraph }
    payload_weight { 50 }
    value { 20 }
    state { 'opened' }

    association :payload, factory: :resource
    association :origin, factory: :planet
    association :destiny, factory: :planet

    trait :with_pilot do
      association :pilot
    end
  end
end