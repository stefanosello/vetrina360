json.extract! tenant, :id, :slug, :name, :additional_info, :created_at, :updated_at
json.url tenant_url(tenant, format: :json)
