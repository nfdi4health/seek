class StudyhubResourceSerializer < SkeletonSerializer
  attributes \
    :resource_type, :nfdi_person_in_charge, :contact_stage, :data_source, \
  :comment, :exclusion_mica_reason, :exclusion_seek_reason, :exclusion_studyhub_reason, \
  :inclusion_studyhub, :inclusion_seek, :inclusion_mica, :resource_json

  has_one :study
  has_one :assay
  has_many :children
  has_many :parents
  has_many :documents
end