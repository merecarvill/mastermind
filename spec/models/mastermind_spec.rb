require 'spec_helper'

describe Mastermind do
  let(:default) { {
    guess_elements: [:red, :green, :orange, :yellow, :blue, :purple],
    code_length: 4,
    max_turns: 10,
  } }
  let(:example_code) { [:blue, :blue, :red, :green] }
  let(:mastermind) { build(:mastermind) }

  describe '#initialize' do

    it 'takes an optional hash of game parameters' do
      expect{Mastermind.new}.not_to raise_error
      expect{Mastermind.new(Hash.new)}.not_to raise_error
    end

    it 'returns an object of type Mastermind' do
      expect(mastermind).to be_a Mastermind
    end

    context 'when no parameters are given' do

      it 'sets guess elements, max turns, code length to default values' do
        set_values = {
          guess_elements: mastermind.guess_elements,
          code_length: mastermind.code_length,
          max_turns: mastermind.max_turns,
        }

        expect(set_values).to eq default
      end
    end
  end

  describe '#new_game' do

    it 'sets the current turn to 1' do
      mastermind.new_game
      expect(mastermind.current_turn).to eq 1
    end
  end

  describe '#advance_one_turn' do

    it 'increments the current turn' do
      mastermind.new_game
      previous_turn = mastermind.current_turn
      mastermind.advance_one_turn
      expect(mastermind.current_turn).to eq previous_turn + 1
    end
  end

  describe '#generate_code' do
    let(:generated_code) { mastermind.generate_code }

    it 'returns an array of the established code length' do
      expect(generated_code.length).to eq mastermind.code_length
    end

    it 'returns an array containing only elements that are guess elements' do
      generated_code.uniq.each do |element|
        expect(mastermind.guess_elements.include?(element)).to eq true
      end
    end

    it 'should not generate the same code every time it is called' do
      different_codes = []
      10.times do
        different_codes << mastermind.generate_code
      end

      expect(different_codes.uniq.length).not_to eq 1
    end
  end

  describe '#compare_guess_to_secret_code' do
    let(:mastermind) { build(:mastermind, secret_code: example_code) }

    it 'takes an guess in array form' do
      guess = Array.new
      expect{mastermind.compare_guess_to_secret_code(guess)}.not_to raise_error
    end

    it 'returns a hash showing num elements in guess matching, close to, or absent from secret code' do
      feedback_types = [:match, :close, :miss]
      guess = [:foo, :foo, :bar, :baz]

      feedback = mastermind.compare_guess_to_secret_code(guess)

      feedback_types.each do |type|
        expect(feedback.has_key?(type)).to be true
      end
    end

    it 'returns all matches if all elements in guess are in secret code and in correct position' do
      guess = mastermind.secret_code
      feedback = mastermind.compare_guess_to_secret_code(guess)

      expect(feedback[:match]).to eq guess.length
      expect(feedback[:close]).to eq 0
      expect(feedback[:miss]).to eq 0
    end

    it 'returns all close if each element in guess is in secret code, but not the correct position' do
      # code: [:blue, :blue, :red, :green]
      #       [CLOSE, CLOSE, CLOSE, CLOSE]
      guess = [:red, :green, :blue, :blue]
      feedback = mastermind.compare_guess_to_secret_code(guess)

      expect(feedback[:match]).to eq 0
      expect(feedback[:close]).to eq guess.length
      expect(feedback[:miss]).to eq 0
    end

    it 'returns all misses if no elements in guess are in secret code' do
      guess = [:foo, :foo, :bar, :baz]
      feedback = mastermind.compare_guess_to_secret_code(guess)

      expect(feedback[:match]).to eq 0
      expect(feedback[:close]).to eq 0
      expect(feedback[:miss]).to eq guess.length
    end

    it 'counts close elements only if each corresponds to a distinct element in secret code' do
      # code: [:blue, :blue, :red, :green]
      #       [CLOSE,  MISS,  MISS,  MISS]
      guess = [:green, :green, :green, :foo]
      feedback = mastermind.compare_guess_to_secret_code(guess)

      expect(feedback[:match]).to eq 0
      expect(feedback[:close]).to eq 1
      expect(feedback[:miss]).to eq guess.length - 1
    end

    it 'gives precedence to counting matches over close elements' do
      # code: [:blue, :blue, :red, :green]
      #       [MISS,  MISS,  MISS,  MATCH]
      guess = [:foo, :foo, :green, :green]
      feedback = mastermind.compare_guess_to_secret_code(guess)

      expect(feedback[:match]).to eq 1
      expect(feedback[:close]).to eq 0
      expect(feedback[:miss]).to eq guess.length - 1
    end
  end
end
