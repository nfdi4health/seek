class StudyhubResourceSerializer < BaseSerializer
  attributes :resource_id, :resource_type, :resource_json
  has_one :study
  has_one :assay
end
