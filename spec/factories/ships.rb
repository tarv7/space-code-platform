FactoryBot.define do
  factory :ship do
    fuel_capacity { 10 }
    fuel_level { 10 }
    weight_capacity { 10 }

    association :pilot
  end
end
