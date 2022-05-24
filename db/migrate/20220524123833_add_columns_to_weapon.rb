class AddColumnsToWeapon < ActiveRecord::Migration[6.1]
  def change
    add_column :weapons, :name, :string
    add_column :weapons, :description, :string
    add_column :weapons, :power_base, :integer, { default => 1 }
    add_column :weapons, :power_step, :integer
    add_column :weapons, :level, :integer, { default => 1 }
  end
end
