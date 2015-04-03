require 'spec_helper'

describe GuessChecker do
  let(:example_code) { [:blue, :blue, :red, :green] }
  let(:checker) { GuessChecker.new(example_code) }

  describe '#initialize' do

    it 'takes a secret code and saves it as an instance variable' do
      expect(GuessChecker.new(example_code).secret_code).to eq example_code
    end
  end

  describe '#compare_to_secret_code' do
    
    it 'takes a guess in array form' do
      guess = Array.new
      expect{checker.compare_to_secret_code(guess)}.not_to raise_error
    end

    it 'returns a hash showing num elements in guess matching, close to, or absent from secret code' do
      feedback_types = [:match, :close, :miss]
      guess = [:foo, :foo, :bar, :baz]

      feedback = checker.compare_to_secret_code(guess)

      feedback_types.each do |type|
        expect(feedback.has_key?(type)).to be true
      end
    end

    it 'returns all matches if all elements in guess are in secret code and in correct position' do
      guess = checker.secret_code
      feedback = checker.compare_to_secret_code(guess)

      expect(feedback[:match]).to eq guess.length
      expect(feedback[:close]).to eq 0
      expect(feedback[:miss]).to eq 0
    end

    it 'returns all close if each element in guess is in secret code, but not the correct position' do
      # code: [:blue, :blue, :red, :green]
      #       [CLOSE, CLOSE, CLOSE, CLOSE]
      guess = [:red, :green, :blue, :blue]
      feedback = checker.compare_to_secret_code(guess)

      expect(feedback[:match]).to eq 0
      expect(feedback[:close]).to eq guess.length
      expect(feedback[:miss]).to eq 0
    end

    it 'returns all misses if no elements in guess are in secret code' do
      guess = [:foo, :foo, :bar, :baz]
      feedback = checker.compare_to_secret_code(guess)

      expect(feedback[:match]).to eq 0
      expect(feedback[:close]).to eq 0
      expect(feedback[:miss]).to eq guess.length
    end

    it 'counts close elements only if each corresponds to a distinct element in secret code' do
      # code: [:blue, :blue, :red, :green]
      #       [CLOSE,  MISS,  MISS,  MISS]
      guess = [:green, :green, :green, :foo]
      feedback = checker.compare_to_secret_code(guess)

      expect(feedback[:match]).to eq 0
      expect(feedback[:close]).to eq 1
      expect(feedback[:miss]).to eq guess.length - 1
    end

    it 'gives precedence to counting matches over close elements' do
      # code: [:blue, :blue, :red, :green]
      #       [MISS,  MISS,  MISS,  MATCH]
      guess = [:foo, :foo, :green, :green]
      feedback = checker.compare_to_secret_code(guess)

      expect(feedback[:match]).to eq 1
      expect(feedback[:close]).to eq 0
      expect(feedback[:miss]).to eq guess.length - 1
    end
  end

end