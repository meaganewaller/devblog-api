# frozen_string_literal: true

class RemoveCounterCacheFromCategory < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      remove_column :categories, :posts_count, :integer
    end
  end
end
