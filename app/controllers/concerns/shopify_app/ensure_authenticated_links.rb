# frozen_string_literal: true

module ShopifyApp
  module EnsureAuthenticatedLinks
    extend ActiveSupport::Concern

    included do
      before_action :redirect_to_splash_page, if: :missing_expected_jwt?
    end

    private

    def splash_page
      splash_page_with_params(shop: current_shopify_domain, host: params[:host])
    end

    def base_splash_page
      root_path(return_to: request.fullpath)
    end

    def splash_page_with_params(params)
      uri = URI(base_splash_page)
      uri.query = CGI.parse(uri.query.to_s)
        .symbolize_keys
        .transform_values { |v| v.one? ? v.first : v }
        .merge(params)
        .to_query
      uri.to_s
    end

    def redirect_to_splash_page
      redirect_to(splash_page)
    rescue ShopifyApp::LoginProtection::ShopifyDomainNotFound => error
      Rails.logger.warn("[ShopifyApp::EnsureAuthenticatedLinks] Redirecting to login: [#{error.class}] "\
                         "Could not determine current shop domain")
      redirect_to(ShopifyApp.configuration.login_url)
    end

    def missing_expected_jwt?
      jwt_shopify_domain.blank?
    end
  end
end
