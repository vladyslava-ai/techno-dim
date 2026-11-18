class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :phone
      t.string :email
      t.string :city
      t.string :address
      t.string :delivery
      t.string :payment
      t.text :comment
      t.string :status
      t.decimal :total, precision: 10, scale: 2

      t.timestamps
    end
  end
end
