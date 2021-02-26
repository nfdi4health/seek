class SampleResourceLink < ApplicationRecord
  belongs_to :sample

  # SampleResourceLink can belong to different type of resource, e.g. Study, Assay
  belongs_to :resource, polymorphic: true
end
