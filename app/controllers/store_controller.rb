class StoreController < ApplicationController
  include StoreVisits
  include CurrentCart
  before_action :set_cart

  def index
    set_visits

    @products = Product.order(:title)
  end
end
