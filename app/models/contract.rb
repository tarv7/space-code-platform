class Contract < ApplicationRecord
  belongs_to :pilot
  belongs_to :payload, class_name: "Resource"
  belongs_to :origin, class_name: "Planet"
  belongs_to :destiny, class_name: "Planet"

  enum state: %i[opened processed finished]

  validates_presence_of :resource_weight, :value, :state
  validates :description, length: { in: 0..5000 }
  validates :resource_weight, numericality: { only_integer: { greater_than: 0 } }
  validates :value, numericality: { only_integer: { greater_than: 0 } }
  validates :state, inclusion: { in: states.keys }
end
