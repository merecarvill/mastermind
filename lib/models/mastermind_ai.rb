class MastermindAI
  attr_accessor :feedback_history

  def initialize(guess_elements, guess_length)
    @feedback_history = []
  end

  def store_feedback(feedback)
    @feedback_history << feedback
  end

  def generate_possible_guesses(guess_elements, guess_length)
    Set.new guess_elements.repeated_permutation(guess_length).to_a
  end
end