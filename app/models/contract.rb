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

  before_commit :report_opened, on: :create

  private

  def report_opened
    return unless opened?

    reports.create(description: "#{description} was opened")
  end
end
