class Ship < ApplicationRecord
  belongs_to :pilot

  validates_presence_of :fuel_capacity, :fuel_level, :weight_capacity
  validates :fuel_capacity, numericality: { only_integer: { greater_than: 0 } }
  validates :fuel_level, numericality: { only_integer: { greater_than_or_equal_to: 0 } }
  validates :weight_capacity, numericality: { only_integer: { greater_than_or_equal_to: 0 } }
end
