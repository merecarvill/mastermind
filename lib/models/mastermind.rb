class Mastermind
  attr_reader :guessable_colors

  def initialize
    @guessable_colors = [:red, :green, :orange, :yellow, :blue, :purple]
  end

  def new_game
  end

  def guessable_color?(color)
    @guessable_colors.include?(color)
  end

  def generate_code(code_length)
    code = []
    code_length.times do
      code << @guessable_colors.sample
    end
    return code
  end
end
