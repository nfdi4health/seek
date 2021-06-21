class CreateStudyhubResourceAuthLookup < ActiveRecord::Migration[5.2]
  def change
    create_table :studyhub_resource_auth_lookup do |t|
      t.references :user
      t.references :asset
      t.integer :can_view, :limit => 1
      t.integer :can_manage, :limit => 1
      t.integer :can_edit, :limit => 1
      t.integer :can_download, :limit => 1
      t.integer :can_delete, :limit => 1
      end
  end
end
