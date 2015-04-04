class MastermindAI
  attr_accessor :feedback_history, :possible_guesses

  def initialize(guess_elements, guess_length)
    @feedback_history = []

    generate_possible_guesses(guess_elements, guess_length)
  end

  def make_guess
    @possible_guesses.first
  end

  def store_feedback(feedback)
    @feedback_history << feedback
  end

  def generate_possible_guesses(guess_elements, guess_length)
    @possible_guesses = Set.new guess_elements.repeated_permutation(guess_length).to_a
  end

  def eliminate_impossible_guesses(guess, feedback)
    checker = GuessChecker.new(guess)
    @possible_guesses.reject! do |possible_guess|
      checker.compare_to_code(possible_guess) != feedback
    end
  end
end