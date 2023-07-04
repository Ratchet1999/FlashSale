class DealSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :quantity, :price_in_cents, :discount_price_in_cents
end
