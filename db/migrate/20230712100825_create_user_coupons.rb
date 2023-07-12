class CreateUserCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :user_coupons do |t|
      t.belongs_to :user
      t.belongs_to :coupon

      t.timestamps
    end
  end
end
