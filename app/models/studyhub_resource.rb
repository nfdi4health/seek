class StudyhubResource < ApplicationRecord

  has_many :studyhub_resource_links, dependent: :destroy
  has_one :study, through: :studyhub_resource_links, source: :resource, source_type: 'Study'
  has_one :assay, through: :studyhub_resource_links, source: :resource, source_type: 'Assay'

  # STUDY = 'study'.freeze
  # DOCUMENT = 'document'.freeze
  #
  # scope :study, -> { where(resource_type: StudyhubResource::STUDY) }


end
