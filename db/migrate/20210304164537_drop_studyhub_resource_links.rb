class DropStudyhubResourceLinks < ActiveRecord::Migration[5.2]

  def up
    drop_table :studyhub_resource_links
  end

  def down
    create_table :studyhub_resource_links do |t|
      t.references :studyhub_resource, foreign_key: true
      t.references :resource, polymorphic: true
    end
  end
end
