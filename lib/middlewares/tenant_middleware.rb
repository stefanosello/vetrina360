# frozen_string_literal: true

class TenantMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    subdomain = extract_subdomain(request.host)

    if subdomain.present?
      tenant = Tenant.find_by(slug: subdomain)
      if tenant
        ActiveRecord::Base.connected_to(role: :writing, shard: tenant.slug.to_sym) do
          return @app.call(env)
        end
      else
        not_found_response("Tenant not found for subdomain: #{subdomain}")
      end
    else
      not_found_response("No subdomain detected")
    end
  end

  private

  def extract_subdomain(host)
    host.split(".").first if host.include?(".")
  end

  def not_found_response(message)
    [404, { "Content-Type" => "text/plain" }, [message]]
  end
end
