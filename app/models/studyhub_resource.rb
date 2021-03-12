class StudyhubResource < ApplicationRecord

  belongs_to :assay, optional: true, dependent: :destroy
  belongs_to :study, optional: true, dependent: :destroy
  # create,update,show via resource_id  not needed anymore since we plan to use SEEK-id as resource_id
  # alias_attribute :id, :resource_id

  validates :resource_id, presence: { message:"Studyhub Resource ID is blank or invalid" }, uniqueness: { message:"Studyhub Resource ID exsits" }
  validates :resource_type, presence: { message:"Studyhub Resource Type is blank or invalid" }

  #add more later
  store_accessor :resource_json, :studySecondaryOutcomes, :studyAnalysisUnit, :acronyms


  STUDY = 'study'.freeze
  SUBSTUDY = 'substudy'.freeze
  DOCUMENT = 'document'.freeze
  INSTRUMENT = 'instrument'.freeze

   scope :studyhub_study, -> { where(resource_type: StudyhubResource::STUDY) }
   scope :studyhub_substudy, -> { where(resource_type: StudyhubResource::SUBSTUDY) }
   scope :studyhub_document, -> { where(resource_type: StudyhubResource::DOCUMENT) }
   scope :studyhub_instrument, -> { where(resource_type: StudyhubResource::INSTRUMENT) }


end
