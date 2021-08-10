class StudyhubResourceSerializer < SkeletonSerializer

  attribute :studyhub_resource_type do
      object.studyhub_resource_type.try(:key)
  end

  attributes :resource_json

  has_many :projects
  has_many :documents

end