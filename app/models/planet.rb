# frozen_string_literal: true

class Planet < ApplicationRecord
  has_many :origin_contracts, class_name: 'Contract', foreign_key: 'origin_id'
  has_many :destiny_contracts, class_name: 'Contract', foreign_key: 'destiny_id'

  validates :name, presence: true, length: { in: 2..255 }

  def quantity_resource_sent(resource)
    origin_contracts.finished.where(payload: resource).sum(:payload_weight)
  end

  def quantity_resource_received(resource)
    destiny_contracts.finished.where(payload: resource).sum(:payload_weight)
  end
end
