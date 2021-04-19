class ChangeStudyhubResourceColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :studyhub_resources, :NFDI_person_in_charge, :nfdi_person_in_charge
    rename_column :studyhub_resources, :Exclusion_MICA_reason, :exclusion_mica_reason
    rename_column :studyhub_resources, :Exclusion_SEEK_reason, :exclusion_seek_reason
    rename_column :studyhub_resources, :Exclusion_StudyHub_reason, :exclusion_studyhub_reason
    rename_column :studyhub_resources, :Inclusion_Studyhub, :inclusion_studyhub
    rename_column :studyhub_resources, :Inclusion_SEEK, :inclusion_seek
    rename_column :studyhub_resources, :Inclusion_MICA, :inclusion_mica
  end
end
