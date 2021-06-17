class ContractSerializer < ActiveModel::Serializer
  attributes :id, :description, :value, :payload

  belongs_to :pilot
  belongs_to :origin
  belongs_to :destiny

  def payload
    ResourceSerializer.new(object.payload, weight: object.payload_weight).serializable_hash
  end
end
