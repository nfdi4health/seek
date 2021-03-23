class StudyhubResourceSerializer < BaseSerializer
  attributes \
  :parent_id, :resource_type, :NFDI_person_in_charge, :contact_stage, :data_source, \
  :comment, :Exclusion_MICA_reason, :Exclusion_SEEK_reason, :Exclusion_StudyHub_reason, \
  :Inclusion_Studyhub, :Inclusion_SEEK, :Inclusion_MICA, :resource_json 
  has_one :study
  has_one :assay
end
