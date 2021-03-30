class CreateStudyhubResourceRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :studyhub_resource_relationships do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps null: false
    end
    add_index :studyhub_resource_relationships, :parent_id
    add_index :studyhub_resource_relationships, :child_id
    add_index :studyhub_resource_relationships, %i[parent_id child_id], unique: true
  end
end
