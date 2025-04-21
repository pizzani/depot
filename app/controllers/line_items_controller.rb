class LineItemsController < ApplicationController
  skip_before_action :authorize, only: %i[ create ]
  include CurrentCart
  include StoreVisits
  before_action :set_cart, only: %i[ create ]
  before_action :set_line_item, only: %i[ show edit update destroy reduce_product_quantity_by_unit ]

  # GET /line_items or /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1 or /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items or /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    respond_to do |format|
      if @line_item.save
        reset_visits

        format.turbo_stream { @current_item = @line_item }
        format.html { redirect_to store_index_url }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1 or /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        reset_visits

        format.html { redirect_to store_index_url, notice: "Line item was successfully updated." }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1 or /line_items/1.json
  def destroy
    product = @line_item.product
    @line_item.destroy!

    respond_to do |format|
      format.html { redirect_to store_index_url, status: :see_other, notice: "#{product.title} removed from cart." }
      format.json { head :no_content }
    end
  end

  def reduce_product_quantity_by_unit
    # This method have the responsability to reduce the quantity of product until 0
    # when 0 is reached it should call the destroy method to end it and remove from cart.
    # Of course a product can only have its quantity reduced if its above 0 so thats the first check
    if @line_item.quantity <= 1
      destroy
    else
      @line_item.quantity -= 1
      respond_to do |format|
        if @line_item.save
          format.html { redirect_to store_index_url }
          format.json { render :show, status: :ok, location: @line_item }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @line_item.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.expect(line_item: [ :product_id ])
    end
end
