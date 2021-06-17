class Contract < ApplicationRecord  
  belongs_to :pilot, optional: true
  belongs_to :payload, class_name: "Resource"
  belongs_to :origin, class_name: "Planet"
  belongs_to :destiny, class_name: "Planet"

  enum state: { opened: 'opened', processing: 'processing', finished: 'finished' }, _default: :opened

  scope :opened, -> { where(state: 'opened') }

  validates_presence_of :payload_weight, :value, :state
  validates :description, length: { maximum: 5000 }
  validates :payload_weight, numericality: { greater_than: 0 }
  validates :value, numericality: { greater_than: 0 }
end
