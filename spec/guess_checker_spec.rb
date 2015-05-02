require 'spec_helper'

describe GuessChecker do
  let(:example_code) { [:blue, :blue, :red, :green] }
  let(:checker) { GuessChecker.new(example_code) }

  describe '#initialize' do

    it 'takes a code' do
      expect{checker}.not_to raise_error
    end

    it 'saves the given code as an instance variable' do
      expect(checker.code).to eq example_code
    end

    it 'returns an object of type GuessChecker' do
      expect(checker).to be_a GuessChecker
    end
  end

  describe '#compare_to_code' do

    it 'returns num elements in given guess matching, close to, or absent from secret code' do
      feedback = checker.compare_to_code(example_code.shuffle)

      expect(feedback.has_key?(:match)).to be true
      expect(feedback.has_key?(:close)).to be true
      expect(feedback.has_key?(:miss)).to be true
    end

    it 'returns all matches if all elements in guess are in secret code and in correct position' do
      feedback = checker.compare_to_code(example_code)

      expect(feedback[:match]).to eq example_code.length
      expect(feedback[:close]).to eq 0
      expect(feedback[:miss]).to eq 0
    end

    it 'returns all close if each element in guess is in secret code, but not the same position' do
      # code: [:blue, :blue, :red, :green]
      #       [CLOSE, CLOSE, CLOSE, CLOSE]
      guess = [:red, :green, :blue, :blue]
      feedback = checker.compare_to_code(guess)

      expect(feedback[:match]).to eq 0
      expect(feedback[:close]).to eq guess.length
      expect(feedback[:miss]).to eq 0
    end

    it 'returns all misses if no elements in guess are in secret code' do
      guess = [:foo, :foo, :bar, :baz]
      feedback = checker.compare_to_code(guess)

      expect(feedback[:match]).to eq 0
      expect(feedback[:close]).to eq 0
      expect(feedback[:miss]).to eq guess.length
    end

    it 'counts close elements only if each corresponds to a distinct element in secret code' do
      # code: [:blue, :blue, :red, :green]
      #       [CLOSE,  MISS,  MISS,  MISS]
      guess = [:green, :green, :green, :foo]
      feedback = checker.compare_to_code(guess)

      expect(feedback[:match]).to eq 0
      expect(feedback[:close]).to eq 1
      expect(feedback[:miss]).to eq guess.length - 1
    end

    it 'gives precedence to counting matches over close elements' do
      # code: [:blue, :blue, :red, :green]
      #       [MISS,  MISS,  MISS,  MATCH]
      guess = [:foo, :blue, :blue, :blue]
      feedback = checker.compare_to_code(guess)

      expect(feedback[:match]).to eq 1
      expect(feedback[:close]).to eq 1
      expect(feedback[:miss]).to eq guess.length - 2
    end
  end

  describe '#correct_feedback?' do

    it 'checks whether given guess results in given feedback when compared to secret code' do
      # code: [:blue, :blue, :red, :green]
      #       [CLOSE,  MISS,  MISS,  MATCH]
      guess = [:red, :green, :green, :green]
      correct_feedback = {match: 1, close: 1, miss: 2}
      incorrect_feedback = {match: 0, close: 3, miss: 1}

      expect(checker.correct_feedback?(guess, correct_feedback)).to be true
      expect(checker.correct_feedback?(guess, incorrect_feedback)).to be false
    end
  end

  describe '#get_matches' do

    it 'returns the elements in a guess matching the element in the same position in the secret code' do
      # code: [:blue, :blue, :red, :green]
      guess = [:blue, :blue, :red, :foo]
      expect(checker.get_matches(guess)).to eq guess - [:foo]
    end

    it 'returns empty array if there are no matches' do
      guess = [:foo, :foo, :foo, :foo]
      expect(checker.get_matches(guess)).to eq []
    end
  end

  describe '#count_close_elements' do

    it 'counts the number of given elements present in the secret code, minus exact matches' do
      # code: [:blue, :blue, :red, :green]
      #       [CLOSE,  MATCH,  CLOSE,  CLOSE]
      guess = [:green, :blue, :blue, :red]
      matches = checker.get_matches(guess)
      expect(checker.count_close_elements(guess, matches)).to eq 3
    end
  end

  describe '#make_new_array_minus_elements' do
    let(:example_array) { [1, 1, 2, 3] }

    it 'returns new array with the given elements removed from the original one-for-one' do
      expect(checker.make_new_array_minus_elements(example_array, [1, 2])).to eq [1, 3]
    end

    it 'ignores given elements not present in original array' do
      expect(checker.make_new_array_minus_elements(example_array,[1, 2, 100, :foo])).to eq [1, 3]
    end

  end

  describe '#remove_element_from' do
    let(:example_array) { [1, 1, 2, 3] }

    context 'if given element is in array' do

      it 'deletes the first occurrence of given element from array' do
        checker.remove_element_from(example_array, 1)
        expect(example_array).to eq [1, 2, 3]
      end

      it 'returns the deleted item' do
        expect(checker.remove_element_from(example_array, 1)).to eq 1
      end
    end

    context 'if given item is not in array' do

      it 'does not change the array' do
        example_array_before = example_array.dup
        checker.remove_element_from(example_array, 0)
        expect(example_array).to eq example_array_before
      end

      it 'returns nil' do
        expect(checker.remove_element_from(example_array, 0)).to be nil
      end
    end
  end
end