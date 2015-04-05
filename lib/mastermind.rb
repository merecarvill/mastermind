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
    @interface.display_instructions

    secret_code = @interface.solicit_code until code_valid?(secret_code)
    @guess_checker = GuessChecker.new(secret_code)

    @max_turns.times do
      ai_guess = @ai.make_guess
      @interface.display_guess(ai_guess)

      feedback = @interface.solicit_feedback until guess_checker.correct_feedback?(ai_guess, feedback)

      if feedback[:match] == @code_length
        @interface.display_code_maker_lost
        return
      end

      @ai.eliminate_codes_producing_different_feedback(ai_guess, feedback)
    end

    @interface.display_code_maker_won
  end

  def code_valid?(code)
    return false if code == nil

    code.length == @code_length && code.reduce{ |bool, element| bool && @code_elements.include?(element) }
  end
end
