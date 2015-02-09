Rails.application.config.generators do |g|
  g.test_framework :rspec, :view_specs => false,
                           :controller_specs => false,
                           :request_specs => true,
                           :routing_specs => false
end
