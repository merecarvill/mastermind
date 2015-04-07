require 'rubygems'

require_relative '../lib/mastermind'

shared_context 'default_values' do
  before :all do
    @default_code_elements = [:red, :green, :orange, :yellow, :blue, :purple]
    @default_code_length = 4
    @default_max_turns = 10
  end
end