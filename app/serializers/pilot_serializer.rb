class PilotSerializer < ActiveModel::Serializer
  attributes :id, :certification, :name, :age, :credits

  belongs_to :location
  has_one :ship
end
