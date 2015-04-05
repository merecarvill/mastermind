require_relative 'game_interface'
require_relative 'guess_checker'
require_relative 'mastermind_ai'
require_relative 'core_extensions'

class Mastermind
  attr_reader :ai, :interface, :code_elements, :code_length, :max_turns

  def initialize(params = {})
    @code_elements = params[:code_elements] ||= [:red, :green, :orange, :yellow, :blue, :purple]
    @max_turns = params[:max_turns] ||= 10
    @code_length = params[:code_length] ||= 4
    @ai = MastermindAI.new(@code_elements, @code_length)
    @interface = GameInterface.new(@code_elements, @code_length)
  end

  def new_game
    set_up_game

    @max_turns.times do
      ai_guess = make_and_show_guess_with_code_reminder
      feedback = handle_feedback(ai_guess)
      if code_guessed?(feedback)
        @interface.display_code_maker_lost
        return
      end
    end

    @interface.display_code_maker_won
  end

  def set_up_game
    @interface.display_instructions
    secret_code = @interface.solicit_code until code_valid?(secret_code)
    @guess_checker = GuessChecker.new(secret_code)
    @secret_code = secret_code
  end

  def make_and_show_guess_with_code_reminder
    ai_guess = @ai.make_guess
    @interface.display_guess(ai_guess)
    @interface.display_code_reminder(@secret_code)
    return ai_guess
  end

  def handle_feedback(ai_guess)
    feedback = @interface.solicit_feedback until @guess_checker.correct_feedback?(ai_guess, feedback)
    @ai.eliminate_codes_producing_different_feedback(ai_guess, feedback)
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
