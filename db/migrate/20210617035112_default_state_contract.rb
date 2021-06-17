class DefaultStateContract < ActiveRecord::Migration[6.1]
  def change
    change_column :contracts, :state, :string, default: :opened
  end
end
