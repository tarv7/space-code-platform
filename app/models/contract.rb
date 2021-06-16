class Contract < ApplicationRecord  
  belongs_to :pilot, optional: true
  belongs_to :payload, class_name: "Resource"
  belongs_to :origin, class_name: "Planet"
  belongs_to :destiny, class_name: "Planet"

  enum state: %i[opened processing finished]

  validates_presence_of :payload_weight, :value, :state
  validates :description, length: { in: 0..5000 }
  validates :payload_weight, numericality: { only_integer: { greater_than: 0 } }
  validates :value, numericality: { only_integer: { greater_than: 0 } }
end
