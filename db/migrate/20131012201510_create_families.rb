class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.string :last_name
      t.string :first_name
      t.string :phone
      t.text :address
      t.text :directions
      t.integer :family_size
      t.integer :children_size
      t.boolean :food_only
      t.integer :box
      t.integer :children_count
      t.boolean :pickup
      t.boolean :flag
      t.datetime :completed_at
      t.boolean :reserve

      t.timestamps
    end
  end
end
