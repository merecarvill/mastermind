class MastermindAI
  attr_accessor :feedback_history

  def initialize(guessable_colors, code_length)
    @guessable_colors = guessable_colors
    @code_length = code_length
    @feedback_history = []
  end

  def store_feedback(feedback)
    @feedback_history << feedback
  end
end