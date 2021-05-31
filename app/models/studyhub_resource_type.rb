class StudyhubResourceType < ApplicationRecord

  has_many :studyhub_resources, inverse_of: :studyhub_resource_type

end
