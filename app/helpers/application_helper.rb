module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_field", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def price_in_dollar(price)
    price.to_fs(:currency, unit: '$', format: '%u %n')
  end

  def price_in_user_currency(price)
    price.to_fs(:currency, unit: current_user.currency_preference, format: '%u %n')
  end

  def price_in_currency(price)
    if user_signed_in?
      converted_price(price).to_fs(:currency, unit: current_user.currency_preference, format: '%u %n')
    else
      price_in_dollar(price)
    end
  end

  def converted_price(price)
    if user_signed_in?
      price * Currency.current_rate[current_user.currency_preference].to_f
    else
      price_in_dollar(price)
    end
  end

  def convert_to_currency(price, currency)
    price / Currency.current_rate[currency].to_f
  end
end
