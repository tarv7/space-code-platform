# frozen_string_literal: true

class Ship < ApplicationRecord
  belongs_to :pilot

  validates_presence_of :fuel_capacity, :fuel_level, :weight_capacity
  validates :fuel_capacity, numericality: { greater_than: 0 }
  validates :fuel_level, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :fuel_capacity }
  validates :weight_capacity, numericality: { greater_than_or_equal_to: 0 }
end
