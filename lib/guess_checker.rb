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
    guess.each_with_index.with_object([]) do |(guess_element, index), matches|
      code_element = @code[index]
      matches << guess_element if guess_element == code_element
    end
  end

  def count_close_elements(guess, matching_elements)
    guess_elements_minus_matches = make_new_array_minus_elements(guess, matching_elements)
    code_elements_minus_matches = make_new_array_minus_elements(@code, matching_elements)
    num_close = 0

    guess_elements_minus_matches.each do |element|
      if code_elements_minus_matches.include?(element)
        num_close += 1
        remove_element_from(code_elements_minus_matches, element)
      end
    end
    num_close
  end

  def make_new_array_minus_elements(array, elements)
    elements.each_with_object(array.dup) do |element, new_array|
      remove_element_from(new_array, element)
    end
  end

  def remove_element_from(array, element)
    array.delete_at(array.index(element) || array.length)
  end

  def correct_feedback?(guess, feedback)
    compare_to_code(guess) == feedback
  end
end