FactoryBot.define do
  factory :pilot do
    certification { Luhn.generate(7) }
    name { Faker::Name.name }
    age { 20 }
    credits { 10 }

    association :location, factory: :planet
  end
end