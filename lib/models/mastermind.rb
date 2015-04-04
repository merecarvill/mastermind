class Mastermind
  attr_reader :guess_checker, :ai, :interface, :guess_elements, :code_length, :max_turns, :current_turn

  def initialize(params = {})
    @guess_elements = params[:guess_elements] ||= [:red, :green, :orange, :yellow, :blue, :purple]
    @max_turns = params[:max_turns] ||= 10
    @code_length = params[:code_length] ||= 4
    @guess_checker = GuessChecker.new(params[:secret_code] ||= generate_code)
    @ai = MastermindAI.new(@guess_elements, @code_length)
    @interface = GameInterface.new
  end

  def new_game
    @current_turn = 1

    @interface.display_instructions(@guess_elements, @code_length)
    @interface.solicit_code

    while @current_turn <= @max_turns
      ai_guess = @ai.make_guess
      @interface.display_guess(ai_guess)

      feedback = @interface.solicit_feedback

      if feedback[:match] == @code_length
        @interface.display_code_maker_lost
        return
      end

      @ai.eliminate_impossible_guesses(ai_guess, feedback)
      @current_turn += 1
    end

    @interface.display_code_maker_won
  end

  def advance_one_turn
    @current_turn += 1
  end

  def generate_code
    @code_length.times.with_object(Array.new) do |i, code|
      code << @guess_elements.sample
    end
  end

  def secret_code
    @guess_checker.code
  end
end
