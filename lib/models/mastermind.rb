class Mastermind
  attr_accessor :guess_checker, :guess_elements, :max_turns, :current_turn, :code_length

  def initialize(params = {})
    @guess_elements = params[:guess_elements] ||= [:red, :green, :orange, :yellow, :blue, :purple]
    @max_turns = params[:max_turns] ||= 10
    @code_length = params[:code_length] ||= 4
    @guess_checker = GuessChecker.new(params[:secret_code] ||= generate_code)
  end

  def new_game
    @current_turn = 1
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
