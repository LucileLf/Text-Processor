class AddColumnsToTextFiles < ActiveRecord::Migration[7.0]
  def change
    add_column :text_files, :format, :string
    add_column :text_files, :text_content, :text
  end
end
