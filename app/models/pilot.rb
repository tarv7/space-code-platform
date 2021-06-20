# frozen_string_literal: true

class Pilot < ApplicationRecord
  belongs_to :location, class_name: 'Planet'

  has_many :ships, dependent: :destroy
  has_many :contracts, dependent: :nullify
  has_many :reports, as: :reportable

  validates_presence_of :certification, :name, :age, :credits
  validates :certification, uniqueness: true, length: { is: 7 }
  validates :name, length: { in: 2..255 }
  validates :age, numericality: { greater_than: 0 }
  validates :credits, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_luhn_certification

  accepts_nested_attributes_for :ships

  def validate_luhn_certification
    return if Luhn.valid?(certification)

    errors.add :certification, I18n.t('activerecord.errors.pilot.luhn_certification')
  end

  def quantity_resource(resource)
    contracts.finished.where(payload: resource).sum(:payload_weight)
  end
end
