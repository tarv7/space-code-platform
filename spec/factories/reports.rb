# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    description { Faker::ChuckNorris.fact }

    association :reportable, factory: :pilot
  end
end
