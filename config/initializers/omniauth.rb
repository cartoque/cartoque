require 'omniauth/enterprise'

cas_server = Rails.env == 'production' ? 'https://authentification-cerbere.application.i2/cas/' : 'http://localhost:9292'
Rails.application.config.middleware.use OmniAuth::Strategies::CAS, :cas_server => cas_server
