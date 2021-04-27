class StudyhubResource < ApplicationRecord

  belongs_to :assay, optional: true, dependent: :destroy
  belongs_to :study, optional: true, dependent: :destroy

  has_many :children_relationships, class_name: 'StudyhubResourceRelationship',
                                    foreign_key: 'parent_id',
                                    dependent: :destroy

  has_many :children, through: :children_relationships

  has_many :parents_relationships, class_name: 'StudyhubResourceRelationship',
                                   foreign_key: 'child_id',
                                   dependent: :destroy

  has_many :parents, through: :parents_relationships
  has_many :documents, through: :assay


  validates :resource_type, presence: { message:'Studyhub Resource Type is blank or invalid' }
  validate :check_title_uniqueness
  validate :resource_type_not_changed, on: :update

  #todo: add more validations later

  store_accessor :resource_json, :studySecondaryOutcomes, :studyAnalysisUnit, :acronyms
  attr_readonly :resource_type

  STUDY = 'study'.freeze
  SUBSTUDY = 'substudy'.freeze
  DOCUMENT = 'document'.freeze
  INSTRUMENT = 'instrument'.freeze

  scope :studyhub_study, -> { where(resource_type: StudyhubResource::STUDY) }
  scope :studyhub_substudy, -> { where(resource_type: StudyhubResource::SUBSTUDY) }
  scope :studyhub_document, -> { where(resource_type: StudyhubResource::DOCUMENT) }
  scope :studyhub_instrument, -> { where(resource_type: StudyhubResource::INSTRUMENT) }

  def title
    if resource_json.nil?
      'No title.'
    else
      "#{resource_json['titles'].first['title']}"
    end
  end

  def check_title_uniqueness
    title = resource_json['titles'].first['title']
    errors.add(:title, 'A studyhub resource with the same title exists. ') unless Study.where(:title => title).blank? && Assay.where(:title => title).blank?
  end

  def resource_type_not_changed
    if resource_type_changed? && self.persisted?
      errors.add(:resource_type, "Change of resource type is not allowed!")
    end
  end

  def add_child(child)
    children_relationships.create(child_id: child.id)
  end

  def remove_child(child)
    children_relationships.find_by(child_id: child.id).destroy
  end

  def is_parent?(child)
    children.include?(child)
  end

  def add_parent(parent)
    parents_relationships.create(parent_id: parent.id)
  end

  def remove_parent(parent)
    parents_relationships.find_by(parent_id: parent.id).destroy
  end

  def is_child?(parent)
    parents.include?(parent)
  end

end
