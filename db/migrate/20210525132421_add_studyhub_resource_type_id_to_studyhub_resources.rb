class AddStudyhubResourceTypeIdToStudyhubResources < ActiveRecord::Migration[5.2]
  def change
    add_column :studyhub_resources,:studyhub_resource_type_id, :int
  end
end
