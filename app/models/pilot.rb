class Pilot < ApplicationRecord
  belongs_to :location, class_name: "Planet"

  validates_presence_of :certification, :name, :age, :credits
  validates :certification, length: { is: 7 }
  validates :name, length: { in: 2..255 }
  validates :age, numericality: { only_integer: { greater_than: 0 } }
  validates :credits, numericality: { only_integer: { greater_than_or_equal_to: 0 } }
  validate :check_luhn_certification

  def check_luhn_certification
    return if Luhn.valid?(certification)

    self.errors.add :certification, "Certification must follow the Luhn standard"
  end
end
