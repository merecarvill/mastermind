class MastermindAI
  attr_accessor :possible_guesses

  def initialize(guess_elements, guess_length)
    generate_possible_guesses(guess_elements, guess_length)
  end

  def make_guess
    @possible_guesses.sample
  end

  def generate_possible_guesses(guess_elements, guess_length)
    @possible_guesses = guess_elements.repeated_permutation(guess_length).to_a
  end

  def eliminate_impossible_guesses(guess, feedback)
    checker = GuessChecker.new(guess)
    @possible_guesses.reject! do |possible_guess|
      checker.compare_to_code(possible_guess) != feedback
    end
  end
end