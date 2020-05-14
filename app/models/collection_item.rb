class CollectionItem < ApplicationRecord
  belongs_to :asset, polymorphic: true, inverse_of: :assay_assets
  belongs_to :collection, inverse_of: :items
  validates :asset_id, uniqueness: { scope: %i[asset_type collection_id], message: 'already included in collection' }
  validates :asset, presence: true
  before_create :set_order

  enforce_authorization_on_association :asset, :view

  private

  def set_order
    self.order ||= (collection.items.maximum(:order) || 0) + 1
  end
end
