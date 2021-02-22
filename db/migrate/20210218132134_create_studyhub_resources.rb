class CreateStudyhubResources < ActiveRecord::Migration[5.2]
  def change
    create_table :studyhub_resources do |t|
      t.integer :parent_id
      t.integer :resource_id
      t.string :resource_type
      t.json :resource_json
      t.string :NFDI_person_in_charge
      t.string :contact_stage
      t.string :data_source
      t.string :comment
      t.string :Exclusion_MICA_reason
      t.string :Exclusion_SEEK_reason
      t.string :Exclusion_StudyHub_reason
      t.boolean :Inclusion_Studyhub
      t.boolean :Inclusion_SEEK
      t.boolean :Inclusion_MICA

      t.timestamps
    end
  end
end
