class RemoveResourceIdFromStudyhubResources < ActiveRecord::Migration[5.2]

  def up
    remove_column :studyhub_resources, :resource_id, :integer
  end

  def down
    add_column :studyhub_resources, :resource_id, :integer
  end

end

