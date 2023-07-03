class RenameColumnDealsTaxToTaxPercentageInDeals < ActiveRecord::Migration[7.0]
  def change
    rename_column :deals, :deals_tax, :tax_percentage
  end
end
