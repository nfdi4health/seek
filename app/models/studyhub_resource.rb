class StudyhubResource < ApplicationRecord

  has_one :studyhub_resource_link, dependent: :destroy
  has_one :study, through: :studyhub_resource_link, source: :resource, source_type: 'Study', dependent: :destroy
  has_one :assay, through: :studyhub_resource_link, source: :resource, source_type: 'Assay', dependent: :destroy

  validates :resource_id, presence: { message:"Studyhub Resource ID is blank or invalid" }, uniqueness: { message:"Studyhub Resource ID exsits" }
  validates :resource_type, presence: { message:"Studyhub Resource Type is blank or invalid" }

  #add more later
  store_accessor :resource_json, :studySecondaryOutcomes, :studyAnalysisUnit, :acronyms


  STUDY = 'study'.freeze
  SUBSTUDY = 'substudy'.freeze
  DOCUMENT = 'document'.freeze
  INSTRUMENT = 'instrument'.freeze

   scope :study, -> { where(resource_type: StudyhubResource::STUDY) }
   scope :substudy, -> { where(resource_type: StudyhubResource::SUBSTUDY) }
   scope :document, -> { where(resource_type: StudyhubResource::DOCUMENT) }
   scope :instrument, -> { where(resource_type: StudyhubResource::INSTRUMENT) }


end
