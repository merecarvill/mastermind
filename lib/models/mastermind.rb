class Mastermind
  attr_accessor :secret_code
  attr_reader :guessable_colors, :max_turns, :current_turn

  def initialize
    @guessable_colors = [:red, :green, :orange, :yellow, :blue, :purple]
  end

  def new_game
    @secret_code = generate_code(4)
    @max_turns = 10
    @current_turn = 1
  end

  def guessable_color?(color)
    @guessable_colors.include?(color)
  end

  def generate_code(code_length)
    code_length.times.with_object(Array.new) do |i, code|
      code << @guessable_colors.sample
    end
  end

  def compare_guess_to_secret_code(guess)
    feedback = {match: 0, close: 0, miss: 0}
    color_frequencies = @secret_code.frequencies
    close_colors_or_misses = []

    guess.length.times do |index|
      guess_color = guess[index]
      code_color = @secret_code[index]

      if guess_color == code_color
        feedback[:match] += 1
        color_frequencies[code_color] -= 1
      else
        close_colors_or_misses << guess_color
      end
    end

    close_colors_or_misses.each do |color|
      if color_frequencies[color] > 0
        feedback[:close] += 1
        color_frequencies[color] -= 1
      end
    end

    feedback[:miss] = guess.length - feedback[:match] - feedback[:close]

    return feedback
  end
end
