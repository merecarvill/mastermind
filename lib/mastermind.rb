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

    init_guess_checker_with_valid_code_from_player
  end

  def init_guess_checker_with_valid_code_from_player
    secret_code = @interface.solicit_code until code_valid?(secret_code)
    @guess_checker = GuessChecker.new(secret_code)
  end

  def run_game
    @max_turns.times do
      @interface.clear_screen
      handle_one_turn

      if code_guessed?(@ai.last_feedback_received)
        @interface.display_player_lost
        return
      end
    end
    @interface.display_player_won
  end

  def handle_one_turn
      @ai.make_guess
      display_guess_with_secret_code_reminder(@ai.last_guess_made)

      correct_feedback = @guess_checker.compare_to_code(@ai.last_guess_made)
      player_feedback = get_correct_feedback_from_player(correct_feedback)
      @ai.receive_feedback(player_feedback)
  end

  def display_guess_with_secret_code_reminder(ai_guess)
    @interface.display_guess(ai_guess)
    @interface.display_code_reminder(@guess_checker.code)
  end

  def get_correct_feedback_from_player(correct_feedback)
    feedback = @interface.solicit_feedback until feedback == correct_feedback
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
