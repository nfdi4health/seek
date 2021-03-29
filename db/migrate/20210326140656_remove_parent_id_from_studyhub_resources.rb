class RemoveParentIdFromStudyhubResources < ActiveRecord::Migration[5.2]
  def up
    remove_column :studyhub_resources, :parent_id, :string
  end

  def down
    add_column :studyhub_resources, :parent_id, :string
  end
end
