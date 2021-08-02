class StudyhubResourceSerializer < SkeletonSerializer

  attribute :studyhub_resource_type do
      object.studyhub_resource_type.try(:key)
  end

  attributes \
  :nfdi_person_in_charge, :contact_stage, :data_source, \
  :comment, :exclusion_mica_reason, :exclusion_seek_reason, :exclusion_studyhub_reason, \
  :inclusion_studyhub, :inclusion_seek, :inclusion_mica, :resource_json

  has_many :projects
  has_one :study
  has_one :assay
  has_many :children
  has_many :parents
  has_many :documents
end