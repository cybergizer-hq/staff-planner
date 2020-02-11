class AddColorToRules < ActiveRecord::Migration[5.2]
  def change
    add_column :rules, :color, :string, default: "", null: false
  end
end
