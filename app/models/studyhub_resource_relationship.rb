class StudyhubResourceRelationship < ApplicationRecord
  belongs_to :parent, class_name: "StudyhubResource"
  belongs_to :child, class_name: "StudyhubResource"
  validates :parent_id, presence: true
  validates :child_id, presence: true
end
