require_relative 'game_interface'
require_relative 'guess_checker'
require_relative 'mastermind_ai'

class Mastermind
  attr_accessor :ai, :interface, :guess_checker, :code_elements, :code_length, :max_turns

  def initialize(params = {})
    @code_elements = params[:code_elements] ||= [:red, :green, :orange, :yellow, :blue, :purple]
    @max_turns = params[:max_turns] ||= 10
    @code_length = params[:code_length] ||= 4
    @ai = MastermindAI.new(@code_elements, @code_length)
    @interface = GameInterface.new(@code_elements, @code_length)
  end

  def new_game
    set_up_game
    run_game
  end

  def set_up_game
    @interface.clear_screen
    @interface.display_instructions

    @secret_code = @interface.solicit_code until code_valid?(@secret_code)
    @guess_checker = GuessChecker.new(@secret_code)
  end

  def run_game
    @max_turns.times do
      @interface.clear_screen
      ai_guess = make_and_show_guess_with_code_reminder
      feedback = get_feedback_and_pass_it_to_ai(ai_guess)
      if code_guessed?(feedback)
        @interface.display_code_maker_lost
        return
      end
    end
    @interface.display_code_maker_won
  end

  def make_and_show_guess_with_code_reminder
    ai_guess = @ai.make_guess
    @interface.display_guess(ai_guess)
    @interface.display_code_reminder(@secret_code)
    return ai_guess
  end

  def get_feedback_and_pass_it_to_ai(ai_guess)
    feedback = @interface.solicit_feedback until @guess_checker.correct_feedback?(ai_guess, feedback)
    @ai.receive_feedback(feedback)
    return feedback
  end

  def code_guessed?(feedback)
    feedback[:match] == @code_length
  end

  def code_valid?(code)
    return false if code == nil
    code.length == @code_length && code.reduce{ |bool, element| bool && @code_elements.include?(element) }
  end
end
