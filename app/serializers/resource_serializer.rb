class ResourceSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :weight, if: -> { @instance_options[:weight].present? }

  def weight
    @instance_options[:weight]
  end
end
