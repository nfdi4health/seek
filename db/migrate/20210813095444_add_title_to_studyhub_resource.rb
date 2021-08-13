class AddTitleToStudyhubResource < ActiveRecord::Migration[5.2]
  def change
    add_column :studyhub_resources, :title, :string
  end
end
