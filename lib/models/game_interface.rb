class GameInterface

  def display_instructions(guess_elements, code_length)
    puts "The name of the game is Mastermind. \
You must think of a #{code_length}-element-long code derived from the following elements: \
#{guess_elements} \
\
When asked, you will enter that code, and then the computer will make several attempts to guess it. \
You will be asked to provide feedback on each guess, identifying the number of matches, close \
elements, and misses. \
A 'match' is an element in a guess that exists in your code and is in the correct position. \
A 'close' element exists in your code, but in a different position than where it occurs in the guess. \
A 'miss' is an element in a guess that does not occur in your code. \
Note that for there to be multiple 'close' elements of the same kind, there must be an equivalent 
number of that type of element in the code, otherwise each extra should be counted as a 'miss'. \
eg: A code of 'blue foo foo foo' and a guess of 'bar blue blue blue' would yeild only one 'close'. \
Each of the remaining elements count as a 'miss'."
  end

  def solicit_code
    puts "You may now enter your code, like so: '1st_element 2nd_element ... nth_element'"

    input = STDIN.gets.chomp
    input.split(" ").map{ |c| c.to_sym }
  end

  def display_guess(guess)
    output = "Guess:"
    guess.each do |guess_element|
      output += " " + guess_element.to_s
    end
    puts output
  end

  def solicit_feedback
    puts "Please input feedback on the most recent guess.\
eg: If a guess had 1 match, 3 close, 0 misses, you should type '1 3 0'"

    input = STDIN.gets.chomp
    labels = [:match, :close, :miss]
    Hash[labels.zip(input.split(" ").map{ |c| c.to_i })]
  end

  def display_code_maker_won
    puts "Your code wasn't guessed, so you win! You didn't cheat did you?" 
  end

  def display_code_maker_lost
    puts "Your code was guessed, so you lose! There's always next time." 
  end
end