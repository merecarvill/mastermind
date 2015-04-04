require 'spec_helper'

describe GameInterface do
  before do
    $stdout = StringIO.new
  end

  after :all do
    $stdout = STDOUT
  end

  let(:default) { {
    guess_elements: [:red, :green, :orange, :yellow, :blue, :purple],
    code_length: 4,
    max_turns: 10,
  } }
  let(:example_guess) { [:blue, :blue, :red, :green] }
  let(:interface) { GameInterface.new }

  describe '#display_instructions' do
    let(:msg) {
"The name of the game is Mastermind. \
You must think of a #{default[:code_length]}-element-long code derived from the following elements: \
#{default[:guess_elements]} \
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
Each of the remaining elements count as a 'miss'.\n"
    }

    it 'takes the code length and guess elements for the game and prints instructions' do
      interface.display_instructions(default[:code_length], default[:guess_elements])
      expect($stdout.string).to eq msg
    end
  end

  describe '#display_guess' do

    it 'prints a given guess' do
      interface.display_guess(example_guess)
      expect($stdout.string).to eq "Guess: blue blue red green\n"
    end
  end

  describe '#solicit_feedback' do
    let(:msg) {
"Please input feedback on the most recent guess.\
eg: If a guess had 1 match, 3 close, 0 misses, you should type '1 3 0'\n"
    }

    it 'prints a message soliciting feedback on a guess' do
      interface.solicit_feedback
      allow($stdin).to receive(:gets) { "1 3 0" }
      expect($stdout.string).to eq msg
    end

    it 'returns a feedback hash made from string input by the player' do
      output_hash = {match: 1, close: 3, miss: 0}

      allow($stdin).to receive(:gets) { "1 3 0" }
      expect(interface.solicit_feedback).to eq output_hash
    end
  end

  describe '#display_code_maker_won' do
    let(:msg) { 
"Your code wasn't guessed, so you win! You didn't cheat did you?\n" 
    }

    it 'prints a message telling the player they won' do
      interface.display_code_maker_won
      expect($stdout.string).to eq msg
    end
  end

  describe '#display_code_maker_lost' do
    let(:msg) { 
"Your code was guessed, so you lose! There's always next time.\n" 
    }

    it 'prints a message telling the player they lost' do
      interface.display_code_maker_lost
      expect($stdout.string).to eq msg
    end
  end
end