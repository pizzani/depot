class StoreController < ApplicationController
  include StoreVisits
  def index

    set_visits

    @products = Product.order(:title)
  end
end
