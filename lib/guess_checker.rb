class GuessChecker
  attr_accessor :code

  def initialize(code)
    @code = code
  end

  def compare_to_code(guess)
    feedback = {match: 0, close: 0, miss: 0}
    element_frequencies = @code.frequencies
    close_elements_or_misses = []

    guess.length.times do |index|
      guess_element = guess[index]
      code_element = @code[index]

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