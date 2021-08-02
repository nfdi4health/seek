class CreateDocumentsStudyhubResources < ActiveRecord::Migration[5.2]
  def change
    create_table :documents_studyhub_resources do |t|
      t.references :document
      t.references :studyhub_resource
    end
  end
end
