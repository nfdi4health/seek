class AddLastUsedAtToStudyhubResources < ActiveRecord::Migration[5.2]
  def change
    add_column :studyhub_resources, :last_used_at, :datetime
  end
end
