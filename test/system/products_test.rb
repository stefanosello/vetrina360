require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:one)
  end

  test "visiting the index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "should create product" do
    visit products_url
    click_on "New product"

    fill_in "Additional description", with: @product.additional_description
    fill_in "Description", with: @product.description
    fill_in "Discarded at", with: @product.discarded_at
    fill_in "Lock version", with: @product.lock_version
    fill_in "Model", with: @product.model
    click_on "Create Product"

    assert_text "Product was successfully created"
    click_on "Back"
  end

  test "should update Product" do
    visit product_url(@product)
    click_on "Edit this product", match: :first

    fill_in "Additional description", with: @product.additional_description
    fill_in "Description", with: @product.description
    fill_in "Discarded at", with: @product.discarded_at.to_s
    fill_in "Lock version", with: @product.lock_version
    fill_in "Model", with: @product.model
    click_on "Update Product"

    assert_text "Product was successfully updated"
    click_on "Back"
  end

  test "should destroy Product" do
    visit product_url(@product)
    click_on "Destroy this product", match: :first

    assert_text "Product was successfully destroyed"
  end
end
