require 'rubygems'
require 'factory_girl'

require_relative '../lib/models/mastermind'

require_relative '../spec/factories/masterminds'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end