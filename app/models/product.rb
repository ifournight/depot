class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
                                             with: /[\w:]+\.(jpe?g|png|gif)/i,
                                             message: 'must be a URL for GIF, JPG or PNG image.'
                                           }
  has_many :line_items
  has_many :orders, through: :line_items
  before_destroy :ensure_no_card_items_referenced

  private

  def ensure_no_card_items_referenced
    if line_items.any?
      errors.add(:base, "can't destroy product for still line_item(s) refering it.'")
      throw :abort
    end
  end
end
