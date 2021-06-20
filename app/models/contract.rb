# frozen_string_literal: true

class Contract < ApplicationRecord
  include Stateable

  belongs_to :pilot, optional: true
  belongs_to :payload, class_name: 'Resource'
  belongs_to :origin, class_name: 'Planet'
  belongs_to :destiny, class_name: 'Planet'

  has_many :reports, as: :reportable

  validates_presence_of :payload_weight, :value, :state
  validates :description, length: { maximum: 5000 }
  validates :payload_weight, numericality: { greater_than: 0 }
  validates :value, numericality: { greater_than: 0 }
  validate :validate_same_planets

  before_commit :report_opened, on: :create

  private

  def validate_same_planets
    return if origin != destiny

    errors.add(:destiny, 'is the same as the origin')
  end

  def report_opened
    return unless opened?

    reports.create(description: "#{description} was opened")
  end
end
