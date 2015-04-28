require 'simplecov'
SimpleCov.start 'rails'
require 'factory_girl_rails'

RSpec.configure do |config|
  config.order = "random"
  config.include FactoryGirl::Syntax::Methods
  config.mock_with :rspec do |c|
    c.syntax = [:expect]
  end
end
