class Pilot < ApplicationRecord
  belongs_to :location, class_name: "Planet"

  validates_presence_of :certification, :name, :age, :credits
  validates :certification, length: { is: 7 }
  validates :name, length: { in: 2..255 }
  validates :age, numericality: { only_integer: { greater_than: 0 } }
  validates :credits, numericality: { only_integer: { greater_than_or_equal_to: 0 } }
end
