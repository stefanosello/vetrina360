json.extract! product, :id, :description, :additional_description, :model, :discarded_at, :lock_version, :created_at, :updated_at, :image
json.url product_url(product, format: :json)
