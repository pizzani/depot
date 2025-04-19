class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product
  belongs_to :cart, optional: true

  validates :price, numericality: { greater_than_or_equal_to: 0.01 }

  def total_price
    self.price * quantity
  end
end
