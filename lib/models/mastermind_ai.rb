class MastermindAI
  attr_accessor :feedback_history

  def initialize
    @feedback_history = []
  end

  def store_feedback(feedback)
    @feedback_history << feedback
  end
end