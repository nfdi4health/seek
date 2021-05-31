class StudyhubResource < ApplicationRecord

  belongs_to :assay, optional: true, dependent: :destroy
  belongs_to :study, optional: true, dependent: :destroy
  belongs_to :studyhub_resource_type, inverse_of: :studyhub_resources

  has_many :children_relationships, class_name: 'StudyhubResourceRelationship',
                                    foreign_key: 'parent_id',
                                    dependent: :destroy

  has_many :children, through: :children_relationships

  has_many :parents_relationships, class_name: 'StudyhubResourceRelationship',
                                   foreign_key: 'child_id',
                                   dependent: :destroy

  has_many :parents, through: :parents_relationships
  has_many :documents, through: :assay

  validate :studyhub_resource_type_id_not_changed, on: :update

  store_accessor :resource_json, :studySecondaryOutcomes, :studyAnalysisUnit, :acronyms
  attr_readonly :studyhub_resource_type_id


  def title
    if resource_json.nil?
      'No title.'
    else
      "#{resource_json['titles'].first['title']}"
    end
  end

  #@todo: check this validation, it is not working now
  def studyhub_resource_type_id_not_changed
    if studyhub_resource_type_id_changed? && self.persisted?
      errors.add(:base, "Change of studyhub resource type is not allowed!")
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

  def is_study?
    self.studyhub_resource_type.key == 'study'
  end

  def is_substudy?
    self.studyhub_resource_type.key == 'substudy'
  end

  def is_document?
    self.studyhub_resource_type.key == 'document'
  end

  def is_instrument?
    self.studyhub_resource_type.key == 'instrument'
  end

end
