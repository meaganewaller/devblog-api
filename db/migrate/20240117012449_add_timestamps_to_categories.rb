class AddTimestampsToCategories < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      change_table :categories, bulk: true do |t|
        t.timestamps
      end
    end
  end
end
