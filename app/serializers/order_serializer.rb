class OrderSerializer < ActiveModel::Serializer
  attributes :id, :address_id, :status
end
