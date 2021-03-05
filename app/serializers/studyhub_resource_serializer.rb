class StudyhubResourceSerializer < BaseSerializer
  attributes :parent_id, :resource_id, :resource_type, :resource_json
  has_one :study
  has_one :assay
end
