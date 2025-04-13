class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)
    if current_item
      # If the product is already in the cart, increment its quantity and get the price
      current_item.quantity += 1
      current_item.price = current_item.product.price
    else
      # If the product its not in the cart, create a new line item and get the price
      current_item = line_items.build(product_id: product.id)
      current_item.price = current_item.product.price
    end
    current_item
  end

  def total_price
    line_items.sum { |item| item.total_price }
  end
end
