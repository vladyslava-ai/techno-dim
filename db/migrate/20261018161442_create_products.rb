class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :brand
      t.text :description
      t.text :specs
      t.decimal :price, precision: 10, scale: 2
      t.integer :stock
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
