# frozen_string_literal: true

class ShipSerializer < ActiveModel::Serializer
  attributes :id, :fuel_capacity, :fuel_level, :weight_capacity

  belongs_to :pilot
end
