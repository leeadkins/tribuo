class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|
      t.string :name
      t.string :gender
      t.integer :age
      t.string :age_type
      t.integer :family_id

      t.timestamps
    end
  end
end
