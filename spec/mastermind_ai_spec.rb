require 'spec_helper'

describe MastermindAI do
  include_context 'default_values'
  
  let(:ai) { MastermindAI.new(@default_code_elements, @default_code_length) }

  describe '#initialize' do

    it 'takes a game\'s guess elements and the secret code length' do
      expect{ai}.not_to raise_error
    end

    it 'returns an object of type MastermindAI' do
      expect(ai).to be_a MastermindAI
    end
  end

  describe '#make_guess' do

    it 'returns a guess from the set of possible codes' do
      guess = ai.make_guess
      expect(ai.possible_codes.include?(guess)).to be true
    end
  end

  describe '#receive_feedback' do
    let(:feedback) { {match: 1, close: 2, miss: 1} }
    before do
      ai.last_guess_made = [:blue, :yellow, :green, :red]
    end

    it 'stores given feedback as last feedback received' do
      ai.receive_feedback(feedback)
      expect(ai.last_feedback_received).to eq feedback
    end

    it 'triggers ai to use feedback to eliminate possible codes' do
      num_initial_possible_codes = ai.possible_codes.length
      ai.receive_feedback(feedback)
      expect(ai.possible_codes.length).to be < num_initial_possible_codes
    end
  end

  describe '#generate_possible_codes' do
    let(:elements) { [0, 1] }
    let(:length) { 2 }
    let(:expected_output) { [[1, 1], [1, 0], [0, 1], [0, 0]] }

    it 'takes the guess elements and code length' do
      expect{ai.generate_possible_codes(elements, length)}.to_not raise_error
    end

    it 'stores all possible codes in an instance variable' do
      ai.generate_possible_codes(elements, length)

      expect(ai.possible_codes.length).to eq expected_output.length
      expect(ai.possible_codes).to match_array expected_output
    end
  end

  describe '#eliminate_codes_producing_incompatible_feedback' do
    let(:secret_code) { [:blue, :blue, :red, :green] }
    before do
      ai.last_guess_made = [:blue, :yellow, :green, :red]
      ai.last_feedback_received = {match: 1, close: 2, miss: 1}
      ai.eliminate_codes_producing_incompatible_feedback
    end


    it 'eliminates codes whose feedback != last received feedback when compared to last guess made' do
      expect(ai.possible_codes.include?(ai.last_guess_made)).to be false
      expect(ai.possible_codes.include?(secret_code)).to be true

      expect(ai.possible_codes.include?([:blue, :green, :yellow, :orange])).to be true
      expect(ai.possible_codes.include?([:purple, :yellow, :red, :green])).to be true
      expect(ai.possible_codes.include?([:red, :purple, :green, :blue])).to be true
      expect(ai.possible_codes.include?([:blue, :red, :red, :yellow])).to be true

      # any permutation of the guess can't be the code, since there was one miss
      ai.last_guess_made.permutation(4).to_a.each do |guess_permutation|
        expect(ai.possible_codes.include?(guess_permutation)).to be false
      end

      # given the guess and the code, a code of all the same element is impossible
      @default_code_elements.each do |code_element|
        all_same_code = Array.new(@default_code_length, code_element)
        expect(ai.possible_codes.include?(all_same_code)).to be false
      end
    end
  end
end