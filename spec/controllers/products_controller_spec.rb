require 'rails_helper'

describe 'ProductsController', type: :controller do

  around(:each) do |test|
    ApplicationRecord.connected_to(role: :writing, shard: :exampleretailcompany, &test)
  end

  before(:all) do
    @controller = ProductsController.new
  end

  let(:valid_attributes) {
    {
      description: "Test Product",
      additional_description: "Additional Details",
      model: "ABC123",
      lock_version: 0
    }
  }

  let(:invalid_attributes) {
    {
      description: nil,
      model: nil
    }
  }

  describe "GET #index" do
    it "returns a successful response" do
      Product.create! valid_attributes
      get :index
      expect(response).to be_successful
    end

    it "assigns all products as @products" do
      product = Product.create! valid_attributes
      get :index
      expect(assigns(:products)).to eq([product])
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      product = Product.create! valid_attributes
      get :show, params: { id: product.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns a new product as @product" do
      get :new
      expect(assigns(:product)).to be_a_new(Product)
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      product = Product.create! valid_attributes
      get :edit, params: { id: product.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Product" do
        expect {
          post :create, params: { product: valid_attributes }
        }.to change(Product, :count).by(1)
      end

      it "redirects to the created product" do
        post :create, params: { product: valid_attributes }
        expect(response).to redirect_to(Product.last)
      end

      it "sets a success notice" do
        post :create, params: { product: valid_attributes }
        expect(flash[:notice]).to eq("Product was successfully created.")
      end

      context "with JSON format" do
        it "creates a new Product and returns correct status" do
          post :create, params: { product: valid_attributes }, format: :json
          expect(response).to have_http_status(:created)
        end
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      context "with JSON format" do
        it "returns unprocessable_entity status" do
          post :create, params: { product: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          description: "Updated Product",
          additional_description: "Updated Details"
        }
      }

      it "updates the requested product" do
        product = Product.create! valid_attributes
        put :update, params: { id: product.to_param, product: new_attributes }
        product.reload
        expect(product.description).to eq("Updated Product")
        expect(product.additional_description).to eq("Updated Details")
      end

      it "redirects to the product" do
        product = Product.create! valid_attributes
        put :update, params: { id: product.to_param, product: valid_attributes }
        expect(response).to redirect_to(product)
      end

      context "with JSON format" do
        it "returns success status" do
          product = Product.create! valid_attributes
          put :update, params: { id: product.to_param, product: valid_attributes }, format: :json
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        product = Product.create! valid_attributes
        put :update, params: { id: product.to_param, product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      context "with JSON format" do
        it "returns unprocessable_entity status" do
          product = Product.create! valid_attributes
          put :update, params: { id: product.to_param, product: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested product" do
      product = Product.create! valid_attributes
      expect {
        delete :destroy, params: { id: product.to_param }
      }.to change(Product, :count).by(-1)
    end

    it "redirects to the products list" do
      product = Product.create! valid_attributes
      delete :destroy, params: { id: product.to_param }
      expect(response).to redirect_to(products_url)
      expect(response).to have_http_status(:see_other)
    end

    context "with JSON format" do
      it "returns no_content status" do
        product = Product.create! valid_attributes
        delete :destroy, params: { id: product.to_param }, format: :json
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe "private methods" do
    describe "#set_product" do
      it "raises RecordNotFound for non-existent product" do
        expect {
          get :show, params: { id: 'nonexistent' }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end