require_relative 'mastermind_interface'
require_relative 'guess_checker'
require_relative 'mastermind_ai'

class Mastermind
  attr_accessor :ai, :interface, :guess_checker, :code_elements, :code_length, :max_turns

  def initialize(params = {})
    @code_elements = params[:code_elements] ||= [:red, :green, :orange, :yellow, :blue, :purple]
    @max_turns = params[:max_turns] ||= 10
    @code_length = params[:code_length] ||= 4
    @ai = MastermindAI.new(@code_elements, @code_length)
    @interface = MastermindInterface.new(@code_elements, @code_length, STDIN, STDOUT)
  end

  def new_game
    set_up_game
    run_game
  end

  def set_up_game
    @interface.clear_screen
    @interface.display_instructions

    set_secret_code_to_valid_code_from_player
    @guess_checker = GuessChecker.new(@secret_code)
  end

  def set_secret_code_to_valid_code_from_player
    @secret_code = @interface.solicit_code until code_valid?(@secret_code)
  end

  def run_game
    @max_turns.times do
      @interface.clear_screen

      feedback = handle_one_turn
      if code_guessed?(feedback)
        @interface.display_code_maker_lost
        return
      end
    end
    @interface.display_code_maker_won
  end

  def handle_one_turn
      ai_guess = @ai.make_guess
      display_guess_with_secret_code_reminder(ai_guess)

      feedback = get_valid_feedback_for_guess(ai_guess)
      @ai.receive_feedback(feedback)
      return feedback
  end

  def display_guess_with_secret_code_reminder(ai_guess)
    @interface.display_guess(ai_guess)
    @interface.display_code_reminder(@secret_code)
  end

  def get_valid_feedback_for_guess(ai_guess)
    feedback = @interface.solicit_feedback until @guess_checker.correct_feedback?(ai_guess, feedback)
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
