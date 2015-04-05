require 'spec_helper'

describe MastermindAI do
  let(:default) { {
    code_elements: [:red, :green, :orange, :yellow, :blue, :purple],
    code_length: 4,
    max_turns: 10,
  } }
  let(:ai) { MastermindAI.new(default[:code_elements], default[:code_length]) }

  describe '#initialize' do

    it 'takes a game\'s guess elements and the secret code length' do
      expect{ai}.not_to raise_error
    end

    it 'returns an object of type MastermindAI' do
      expect(ai).to be_a MastermindAI
    end
  end

  describe '#generate_possible_codes' do

    it 'takes the guess elements and code length' do
      elements = [0, 1]
      length = 2

      expect{ai.generate_possible_codes(elements, length)}.to_not raise_error
    end

    it 'stores all possible codes in an instance variable' do
      elements = [0, 1]
      length = 2
      expected_output =[[1, 1], [1, 0], [0, 1], [0, 0]]
      ai.generate_possible_codes(elements, length)

      expect(ai.possible_codes.length).to eq expected_output.length
      expected_output.each do |guess|
        expect(ai.possible_codes.include?(guess)).to eq true
      end
    end
  end

  describe '#eliminate_codes_producing_different_feedback' do
    let(:secret_code) { [:blue, :blue, :red, :green] }
    let(:checker) { GuessChecker.new(secret_code) }


    it 'takes a guess and associated feedback and eliminates all codes not producing the same feedback' do
      # secret code: [:blue, :blue, :red, :green]
      #               [MATCH, MISS, CLOSE, CLOSE]
      guess =        [:blue, :yellow, :green, :red]
      feedback = checker.compare_to_code(guess)
      ai.eliminate_codes_producing_different_feedback(guess, feedback)

      expect(ai.possible_codes.include?(guess)).to be false
      expect(ai.possible_codes.include?(secret_code)).to be true

      expect(ai.possible_codes.include?([:blue, :green, :yellow, :orange])).to be true
      expect(ai.possible_codes.include?([:purple, :yellow, :red, :green])).to be true
      expect(ai.possible_codes.include?([:red, :purple, :green, :blue])).to be true
      expect(ai.possible_codes.include?([:blue, :red, :red, :yellow])).to be true

      # any permutation of the guess can't be the code, since there was one miss
      guess.permutation(4).to_a.each do |guess_permutation|
        expect(ai.possible_codes.include?(guess_permutation)).to be false
      end

      # given the guess and the code, a code of all the same element is impossible
      default[:code_elements].each do |guess_element|
        all_same_code = Array.new(default[:code_length], guess_element)
        expect(ai.possible_codes.include?(all_same_code)).to be false
      end
    end
  end

  describe '#make_guess' do

    it 'returns a guess from the set of possible codes' do
      guess = ai.make_guess
      expect(ai.possible_codes.include?(guess)).to eq true
    end
  end
end