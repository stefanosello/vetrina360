require 'rails_helper'

RSpec.describe Middlewares::TenantMiddleware do
  let(:app) { ->(env) { [ 200, env, [ 'OK' ] ] } }
  let(:middleware) { described_class.new(app) }
  let(:tenant) { instance_double('Tenant', slug: 'tenant1') }

  before do
    allow(Tenant).to receive(:find_by).and_return(nil)
  end

  describe '#call' do
    context 'with valid subdomain and existing tenant' do
      let(:env) { Rack::MockRequest.env_for('http://tenant1.example.com') }

      before do
        allow(Tenant).to receive(:find_by).with(slug: 'tenant1').and_return(tenant)
        allow(ActiveRecord::Base).to receive(:connected_to).and_yield
      end

      it 'connects to the correct tenant shard' do
        expect(ActiveRecord::Base).to receive(:connected_to)
                                        .with(role: :writing, shard: :tenant1)
                                        .and_yield

        middleware.call(env)
      end

      it 'forwards the request to the app' do
        status, headers, body = middleware.call(env)
        expect(status).to eq(200)
      end
    end

    context 'with valid subdomain but non-existent tenant' do
      let(:env) { Rack::MockRequest.env_for('http://nonexistent.example.com') }

      it 'returns a 404 status' do
        status, headers, body = middleware.call(env)
        expect(status).to eq(404)
      end

      it 'returns correct error message' do
        status, headers, body = middleware.call(env)
        expect(body).to eq([ 'Tenant not found for subdomain: nonexistent' ])
      end

      it 'sets content type to text/plain' do
        status, headers, body = middleware.call(env)
        expect(headers['Content-Type']).to eq('text/plain')
      end
    end

    context 'without subdomain' do
      let(:env) { Rack::MockRequest.env_for('http://example.com') }

      it 'returns a 404 status' do
        status, headers, body = middleware.call(env)
        expect(status).to eq(404)
      end

      it 'returns correct error message' do
        status, headers, body = middleware.call(env)
        expect(body).to eq([ 'No subdomain detected' ])
      end
    end
  end

  describe '#extract_subdomain' do
    it 'extracts multilevel subdomain from host with multilevel subdomain' do
      result = middleware.send(:extract_subdomain, 'subtenant1.tenant1.example.com')
      expect(result).to eq('subtenant1.tenant1')
    end

    it 'extracts subdomain from host with subdomain' do
      result = middleware.send(:extract_subdomain, 'tenant1.example.com')
      expect(result).to eq('tenant1')
    end

    it 'returns nil for host without subdomain' do
      result = middleware.send(:extract_subdomain, 'example.com')
      expect(result).to be_nil
    end

    it 'returns nil for host without dots' do
      result = middleware.send(:extract_subdomain, 'localhost')
      expect(result).to be_nil
    end
  end
end
