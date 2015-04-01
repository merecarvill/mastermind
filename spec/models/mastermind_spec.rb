require 'spec_helper'

describe Mastermind do
  let!(:mastermind) { build(:mastermind) }
  let(:guessable_colors) { [:red, :green, :orange, :yellow, :blue, :purple] }
  let(:secret_code_length) { 4 }
  let(:example_code) { [:blue, :blue, :red, :green] }
  let(:max_turns) { 10 }

  describe '#initialize' do

    it 'returns an object of type Mastermind' do
      expect(mastermind).to be_a Mastermind
    end
  end

  describe '#new_game' do

    it 'takes an optional parameter to set the secret code' do
      expect{mastermind.new_game}.not_to raise_error
      expect{mastermind.new_game(example_code)}.not_to raise_error
      expect(mastermind.secret_code).to eq example_code
    end

    it 'sets current turn to 1' do
      mastermind.new_game
      expect(mastermind.current_turn).to eq 1
    end

    it 'sets the max number of turns' do
      mastermind.new_game
      expect(mastermind.max_turns).to eq max_turns
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

  describe '#guessable_color?' do

    it 'takes one perameter' do
      expect{mastermind.guessable_color?(:foo)}.not_to raise_error
    end

    it 'returns true if given a guessable color in symbol form' do
      color = guessable_colors.sample
      expect(mastermind.guessable_color?(color)).to eq true
    end

    it 'returns false if given something that is not a guessable color in symbol form' do
      expect(mastermind.guessable_color?(:foo)).to eq false
    end
  end

  describe '#generate_code' do
    let(:generated_code) { mastermind.generate_code(secret_code_length) }

    it 'takes the desired length of the code' do
      expect{generated_code}.not_to raise_error
    end

    it 'returns an array of the input length' do
      expect(generated_code.length).to eq secret_code_length
    end

    it 'returns an array containing only colors that are guessable colors' do
      generated_code.uniq.each do |color|
        expect(mastermind.guessable_color?(color)).to eq true
      end
    end
  end

  describe '#compare_guess_to_secret_code' do
    let(:mastermind) { build(:mastermind, secret_code: example_code) }

    it 'takes an array' do
      expect{mastermind.compare_guess_to_secret_code(Array.new)}.not_to raise_error
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
