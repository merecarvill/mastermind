require 'rubygems'
require 'factory_girl'

require_relative '../lib/models/mastermind'
require_relative '../lib/models/game_interface'
require_relative '../lib/models/guess_checker'
require_relative '../lib/models/mastermind_ai'
require_relative '../lib/models/core_extensions'

require_relative '../spec/factories/masterminds'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end