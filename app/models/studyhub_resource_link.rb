class StudyhubResourceLink < ApplicationRecord
  belongs_to :studyhub_resource
  belongs_to :resource, polymorphic: true
end
