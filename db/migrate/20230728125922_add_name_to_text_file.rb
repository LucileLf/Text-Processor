class AddNameToTextFile < ActiveRecord::Migration[7.0]
  def change
    add_column :text_files, :name, :string
  end
end
