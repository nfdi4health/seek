class StudyhubResourceType < ApplicationRecord

  has_many :studyhub_resources, inverse_of: :studyhub_resource_type

  def is_study?
    self.key == 'study'
  end

  def is_substudy?
    self.key == 'substudy'
  end


end
