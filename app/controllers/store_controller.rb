class StoreController < ApplicationController
  skip_before_action :authorize
  include StoreVisits
  include CurrentCart
  before_action :set_cart

  def index
    set_visits

    @products = Product.order(:title)
  end
end
