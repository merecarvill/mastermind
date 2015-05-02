require_relative 'guess_checker'

class MastermindAI
  attr_accessor :last_guess_made, :last_feedback_received
  attr_reader :possible_codes

  def initialize(code_elements, code_length)
    generate_possible_codes(code_elements, code_length)
  end

  def make_guess
    @last_guess_made = @possible_codes.sample
  end

  def receive_feedback(feedback)
    @last_feedback_received = feedback
    eliminate_codes_producing_incompatible_feedback
  end

  def generate_possible_codes(code_elements, code_length)
    @possible_codes = code_elements.repeated_permutation(code_length).to_a
  end

  def eliminate_codes_producing_incompatible_feedback
    checker = GuessChecker.new(@last_guess_made)
    @possible_codes.select! do |code|
      checker.compare_to_code(code) == @last_feedback_received
    end
  end
end