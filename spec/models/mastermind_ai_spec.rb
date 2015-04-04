require 'spec_helper'

describe MastermindAI do
  let(:default) { {
    guess_elements: [:red, :green, :orange, :yellow, :blue, :purple],
    code_length: 4,
    max_turns: 10,
  } }
  let(:ai) { MastermindAI.new(default[:guess_elements], default[:code_length]) }

  describe '#initialize' do

    it 'takes a game\'s guess elements and the secret code length' do
      expect{ai}.not_to raise_error
    end

    it 'returns an object of type MastermindAI' do
      expect(ai).to be_a MastermindAI
    end
  end

  describe '#feedback_history' do

    it 'returns an array of hashes, each containing feedback for one guess' do
      feedback_types = [:match, :close, :miss]

      expect(ai.feedback_history).to be_a Array
      ai.feedback_history.each do |feedback|
        feedback_types.each do |type|
          expect(feedback.has_key?(type)).to be true
        end
      end
    end
  end

  describe '#store_feedback' do
    let(:example_feedback) { {match: 1, close: 1, miss: 2} }

    it 'takes a hash containing feedback on a guess' do
      expect{ai.store_feedback(example_feedback)}.not_to raise_error
    end

    it 'adds the hash to those stored in @feedback_history' do
      ai.store_feedback(example_feedback)
      expect(ai.feedback_history.include?(example_feedback)).to eq true
    end
  end

  describe '#generate_possible_guesses' do

    it 'takes the guess elements and length' do
      elements = [0, 1]
      length = 2
      expected_output = Set.new [[1, 1], [1, 0], [0, 1], [0, 0]]

      expect{ai.generate_possible_guesses(elements, length)}.to_not raise_error
    end

    it 'stores all possible guesses in an instance variable' do
      elements = [0, 1]
      length = 2
      expected_output =[[1, 1], [1, 0], [0, 1], [0, 0]]
      ai.generate_possible_guesses(elements, length)

      expect(ai.possible_guesses).to eq expected_output
    end
  end

  describe '#eliminate_impossible_guesses' do
    let(:example_code) { [:blue, :blue, :red, :green] }
    let(:checker) { GuessChecker.new(example_code) }


    it 'takes feedback on a guess and eliminates all guesses that could not produce that feedback' do
      # secret code: [:blue, :blue, :red, :green]
      guess = [:blue, :yellow, :green, :red]
      feedback = checker.compare_to_code(guess) # = {match: 1, close: 2, miss 1}
      ai.eliminate_impossible_guesses(guess, feedback)

      expect(ai.possible_guesses.include?(example_code)).to eq true
      expect(ai.possible_guesses.include?([:blue, :blue, :blue, :blue])).to eq false
      # {match: 1, close: 2, miss 1} != {match: 2, close: 0, miss: 2}
      expect(ai.possible_guesses.include?([:red, :blue, :blue, :green])).to eq false
      # {match: 1, close: 2, miss 1} != {match: 1, close: 3, miss: 0}
      expect(ai.possible_guesses.include?([:yellow, :yellow, :yellow, :yellow])).to eq false
      # {match: 1, close: 2, miss 1} != {match: 0, close: 0, miss: 4}
    end
  end

  describe '#make_guess' do

    it 'returns a guess from the set of possible guesses' do
      guess = ai.make_guess
      expect(ai.possible_guesses.include?(guess)).to eq true
    end
  end
end