class CreateProjectsStudyhubResources < ActiveRecord::Migration[5.2]
  def change
    create_table :projects_studyhub_resources do |t|
      t.references :studyhub_resource
      t.references :project
    end
  end
end
