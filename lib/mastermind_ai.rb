class MastermindAI
  attr_accessor :possible_codes

  def initialize(code_elements, code_length)
    generate_possible_codes(code_elements, code_length)
  end

  def make_guess
    @possible_codes.sample
  end

  def generate_possible_codes(code_elements, code_length)
    @possible_codes = code_elements.repeated_permutation(code_length).to_a
  end

  def eliminate_codes_producing_different_feedback(guess, feedback)
    checker = GuessChecker.new(guess)
    @possible_codes.select! do |code|
      checker.compare_to_code(code) == feedback
    end
  end
end