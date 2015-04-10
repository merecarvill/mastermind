require_relative '../lib/mastermind'

params = {
  code_elements: [:red, :green, :orange, :yellow, :blue, :purple],
  code_length: 4,
  max_turns: 10,
}

Mastermind.new(params).new_game