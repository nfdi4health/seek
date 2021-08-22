class AddStageToStudyhubResource < ActiveRecord::Migration[5.2]
  def change
    add_column :studyhub_resources, :stage, :integer
  end
end
