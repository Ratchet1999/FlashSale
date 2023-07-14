class CreateCurrency < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies do |t|
      t.json :conversion_rates
      t.date :date

      t.timestamps
    end
  end
end
