require 'rubygems'
require 'factory_girl'

require_relative '../lib/mastermind'
require_relative './factories/mastermind'

module Helpers
  def generate_random_code
    (1..@default_code_length).map{ @default_code_elements.sample }
  end

  def has_at_least_one_repeated_line?(string)
    lines = string.split("\n")
    lines.uniq.length < lines.length
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.include FactoryGirl::Syntax::Methods
end

shared_context 'default_values' do
  before :all do
    @default_code_elements = [:red, :green, :orange, :yellow, :blue, :purple]
    @default_code_length = 4
    @default_max_turns = 10
  end
end