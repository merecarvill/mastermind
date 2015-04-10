class MastermindInterface
  attr_reader :game_text

  def initialize(code_elements, code_length, input_stream, output_stream)
    @input_stream = input_stream
    @output_stream = output_stream
    @game_text = generate_game_text(code_elements, code_length)
  end

  def display_instructions
    @output_stream.puts @game_text[:display_instructions]
  end

  def solicit_code
    @output_stream.puts @game_text[:solicit_code]

    input = @input_stream.gets.strip
    input.split(" ").map{ |c| c.to_sym }
  end

  def display_guess(code)
    @output_stream.puts @game_text[:display_guess] + code_to_s(code)
  end

  def display_code_reminder(code)
    @output_stream.puts @game_text[:display_code_reminder] + code_to_s(code)
  end

  def code_to_s(code)
    code.join(" ")
  end

  def solicit_feedback
    @output_stream.puts @game_text[:solicit_feedback]

    num_matches = solicit_feedback_aspect(:match)
    num_close = solicit_feedback_aspect(:close)
    num_misses = solicit_feedback_aspect(:miss)

    {match: num_matches, close: num_close, miss: num_misses}
  end

  def solicit_feedback_aspect(aspect)
    grammatical_insert = aspect == :close ? "" : "a "
    @output_stream.print @game_text[:solicit_feedback_aspect] + grammatical_insert + aspect.to_s + "? "
    return @input_stream.gets.strip.to_i
  end

  def display_player_won
    @output_stream.puts @game_text[:display_player_won]
  end

  def display_player_lost
    @output_stream.puts @game_text[:display_player_lost]
  end

  def clear_screen
    system("cls")
    system("clear")
  end
  
  def generate_game_text(code_elements, code_length)
    game_text = Hash.new 
    game_text[:display_instructions] = <<-eos
The name of the game is Mastermind.

===== INSTRUCTIONS =====
You must think of a #{code_length}-element-long code derived from the following elements:
#{code_elements.join(", ")}
Your guess can contain duplicate elements.

When asked, you will enter that code and the computer will make several attempts to guess it. 
You will be asked to provide feedback on each guess, identifying the number of matches, close 
elements, and misses.

A 'match' is an element in a guess that exists in your code and is in the correct position.
A 'close' element exists in your code, but in a different position than where it occurs in the guess.
A 'miss' is an element in a guess that does not occur in your code.

Note that for there to be multiple 'close' elements of the same kind, there must be an equivalent 
number of that type of element in the code, otherwise each extra should be counted as a 'miss'.
eg: A code of 'blue foo foo foo' and a guess of 'bar blue blue blue' would yeild only one 'close'. 
Each of the remaining elements count as a 'miss'.

eos
    game_text[:solicit_code] = <<-eos
Please enter your code. Separate elements with spaces, like so: 
1st_element 2nd_element ... nth_element
eos
    game_text[:display_guess] = "The computer's guess is: "
    game_text[:display_code_reminder] = "Remember, your code was: "
    game_text[:solicit_feedback] = 
      "\n" + "Input your feedback on the most recent guess (in numeral form, please)."
    game_text[:solicit_feedback_aspect] = "How many elements were "
    game_text[:display_player_won] = "\n" + "Your code wasn't guessed in time, so you win!"
    game_text[:display_player_lost] = "\n" + "Your code was guessed, so you lose!"
    return game_text
  end
end