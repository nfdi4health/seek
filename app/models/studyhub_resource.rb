class StudyhubResource < ApplicationRecord

  has_one :studyhub_resource_link, dependent: :destroy
  has_one :study, through: :studyhub_resource_link, source: :resource, source_type: 'study', dependent: :destroy
  has_one :assay, through: :studyhub_resource_link, source: :resource, source_type: 'assay', dependent: :destroy

  validates :resource_id, presence: { message:"Studyhub Resource ID is blank or invalid" }, uniqueness: { message:"Studyhub Resource ID exsits" }
  validates :resource_type, presence: { message:"Studyhub Resource Type is blank or invalid" }

  store_accessor :resource_json,:studySecondaryOutcomes,:studyAnalysisUnit,:acronyms


  # STUDY = 'study'.freeze
  # DOCUMENT = 'document'.freeze
  #
  # scope :study, -> { where(resource_type: StudyhubResource::STUDY) }


end
