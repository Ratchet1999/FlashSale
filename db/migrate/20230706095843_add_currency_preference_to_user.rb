class AddCurrencyPreferenceToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :currency_preference, :string, default: 'dollar'
  end
end
