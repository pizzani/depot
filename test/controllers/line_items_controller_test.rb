require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:ruby).id }
    end

    follow_redirect!

    assert_select "h2", "Your Cart"
    assert_select "td", "Programming Ruby 1.9"
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item" do
    assert_difference("LineItem.count", -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to store_index_url
  end

  test "should stack line_item for unique and duplicate products" do
    assert_difference("LineItem.count", 2) do
      post line_items_url, params: { product_id: products(:ruby).id }
      post line_items_url, params: { product_id: products(:ruby).id }
      post line_items_url, params: { product_id: products(:one).id }
    end
  end

  test "should creat line_item via turbo_stream" do
    assert_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:ruby).id },
      as: :turbo_stream
    end

    assert_response :success
    assert_match /<tr class="line-item-highlight">/, @response.body
  end

  test "should decrease line_item product quantity by 1 on click" do
    assert_difference("LineItem.sum(:quantity)", 2) do
      2.times do
        post line_items_url, params: { product_id: products(:ruby).id },
        as: :turbo_stream
      end
    end

    line_item = LineItem.find_by(product: products(:ruby))

    assert_difference("LineItem.sum(:quantity)", -1) do
        patch reduce_product_quantity_by_unit_line_item_url(line_item)
    end

    follow_redirect!
    assert_select "td", "1"
  end
end
