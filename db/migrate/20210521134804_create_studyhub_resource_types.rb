class CreateStudyhubResourceTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :studyhub_resource_types do |t|
      t.string :title
      t.string :description
      t.string :key

      t.timestamps
    end
  end
end
