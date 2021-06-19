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
      association :pilot, factory: :pilot_with_ships
    end

    trait :opened do
      state { 'opened' }
    end

    trait :accepted do
      state { 'accepted' }

      with_pilot
    end

    trait :processing do
      state { 'processing' }

      with_pilot
    end

    trait :finished do
      state { 'finished' }

      with_pilot
    end
  end
end