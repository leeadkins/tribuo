class ChangeFamiles < ActiveRecord::Migration
  def change
    change_table :families do |t|
      t.rename :pickup, :delivery
    end
  end
end
