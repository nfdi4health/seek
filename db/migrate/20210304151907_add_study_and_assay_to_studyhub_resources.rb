class AddStudyAndAssayToStudyhubResources < ActiveRecord::Migration[5.2]
  def change
    add_reference :studyhub_resources, :assay
    add_reference :studyhub_resources, :study
  end
end
