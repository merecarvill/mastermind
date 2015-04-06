require 'rubygems'

require_relative '../lib/mastermind'

shared_context 'default_values' do
  let(:default) { {
    code_elements: [:red, :green, :orange, :yellow, :blue, :purple],
    code_length: 4,
    max_turns: 10,
  } }
end