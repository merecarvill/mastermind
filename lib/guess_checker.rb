class GuessChecker
  attr_reader :code

  def initialize(code)
    @code = code
  end

  def compare_to_code(guess)
    matching_elements = get_matches(guess)
    
    num_matches = matching_elements.length
    num_close = count_close_elements(guess, matching_elements)
    num_misses = @code.length - num_matches - num_close

    {match: num_matches, close: num_close, miss: num_misses}
  end

  def get_matches(guess)
    matches = []
    guess.each_with_index do |guess_element, index|
      code_element = @code[index]
      matches << guess_element if guess_element == code_element
    end
    matches
  end

  def count_close_elements(guess, matching_elements)
    guess_elements_minus_matches = guess.subtract_one_for_one(matching_elements)
    code_elements_minus_matches = @code.subtract_one_for_one(matching_elements)
    num_close = 0

    guess_elements_minus_matches.each do |element|
      if code_elements_minus_matches.include?(element)
        num_close += 1
        code_elements_minus_matches.delete_first(element)
      end
    end
    num_close
  end

  def correct_feedback?(guess, feedback)
    compare_to_code(guess) == feedback
  end
end