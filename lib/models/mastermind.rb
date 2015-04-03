class Mastermind
  attr_accessor :secret_code, :guess_elements, :max_turns, :current_turn, :code_length

  def initialize(params = {})
    @guess_elements = params[:guess_elements] || [:red, :green, :orange, :yellow, :blue, :purple]
    @max_turns = params[:max_turns] || 10
    @code_length = params[:code_length] || 4
    @secret_code = params[:secret_code] || generate_code
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

  def compare_guess_to_secret_code(guess)
    feedback = {match: 0, close: 0, miss: 0}
    element_frequencies = @secret_code.frequencies
    close_elements_or_misses = []

    guess.length.times do |index|
      guess_element = guess[index]
      code_element = @secret_code[index]

      if guess_element == code_element
        feedback[:match] += 1
        element_frequencies[code_element] -= 1
      else
        close_elements_or_misses << guess_element
      end
    end

    close_elements_or_misses.each do |element|
      if element_frequencies[element] > 0
        feedback[:close] += 1
        element_frequencies[element] -= 1
      end
    end

    feedback[:miss] = guess.length - feedback[:match] - feedback[:close]

    return feedback
  end
end
