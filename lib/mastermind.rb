require_relative 'game_interface'
require_relative 'guess_checker'
require_relative 'mastermind_ai'
require_relative 'core_extensions'

class Mastermind
  attr_reader :guess_checker, :ai, :interface, :guess_elements, :code_length, :max_turns, :current_turn

  def initialize(params = {})
    @guess_elements = params[:guess_elements] ||= [:red, :green, :orange, :yellow, :blue, :purple]
    @max_turns = params[:max_turns] ||= 10
    @code_length = params[:code_length] ||= 4
    @ai = MastermindAI.new(@guess_elements, @code_length)
    @interface = GameInterface.new(@guess_elements, @code_length)
  end

  def new_game
    @current_turn = 1

    @interface.display_instructions

    secret_code = @interface.solicit_code until valid_code?(secret_code)
    @guess_checker = GuessChecker.new(secret_code)

    while @current_turn <= @max_turns
      ai_guess = @ai.make_guess
      @interface.display_guess(ai_guess)

      feedback = @interface.solicit_feedback until guess_checker.correct_feedback?(guess, feedback)

      if feedback[:match] == @code_length
        @interface.display_code_maker_lost
        return
      end

      @ai.eliminate_impossible_guesses(ai_guess, feedback)
      @current_turn += 1
    end

    @interface.display_code_maker_won
  end

  def code_valid?(code)
    valid_elements = code.reduce{ |bool, element| bool && @guess_elements.include?(element) }
    valid_length = code.length == @code_length
    valid_elements && valid_length
  end

  def secret_code
    @guess_checker.code
  end
end
