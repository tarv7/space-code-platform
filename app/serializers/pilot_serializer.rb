# frozen_string_literal: true

class PilotSerializer < ActiveModel::Serializer
  attributes :id, :certification, :name, :age, :credits

  belongs_to :location
  has_many :ships
end
