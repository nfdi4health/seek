class RemoveStudyhubResourceTypeFromStudyhubResources < ActiveRecord::Migration[5.2]
  def change
    remove_column :studyhub_resources, :resource_type,:string
  end
end
