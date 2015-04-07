require 'spec_helper'

describe Mastermind do
  include_context 'default_values'

  before :all do
    $stdout = StringIO.new
  end
  before :each do
    $stdout.flush
  end
  after :all do
    $stdout = STDOUT
  end
  
  let(:example_code) { [:blue, :blue, :red, :green] }
  let(:mastermind) { Mastermind.new }

  describe '#initialize' do

    it 'takes an optional hash of game parameters' do
      expect{Mastermind.new}.not_to raise_error
      expect{Mastermind.new(Hash.new)}.not_to raise_error
    end

    it 'returns an object of type Mastermind' do
      expect(mastermind).to be_a Mastermind
    end

    it 'makes a MastermindAI' do
      expect(mastermind.ai).to be_a MastermindAI
    end

    it 'makes a GameInterface' do
      expect(mastermind.interface).to be_a GameInterface
    end

    context 'when no parameters are given' do

      it 'sets code elements, code length, max turns to default values' do
        expect(mastermind.code_elements).to eq @default_code_elements
        expect(mastermind.code_length).to eq @default_code_length
        expect(mastermind.max_turns).to eq @default_max_turns
      end
    end

    context 'when given parameters' do
      let(:params) { {
        code_elements: [1, 2, 3],
        code_length: 5,
        max_turns: 8,
      } }
      let(:mastermind_with_params) { Mastermind.new(params) }
      let(:mastermind_with_empty_params) { Mastermind.new(Hash.new) }

      it 'sets code elements, code length, max turns to specified values' do
        expect(mastermind_with_params.code_elements).to eq params[:code_elements]
        expect(mastermind_with_params.code_length).to eq params[:code_length]
        expect(mastermind_with_params.max_turns).to eq params[:max_turns]
      end

      context 'when any given attribute is not specified in parameters' do

        it 'reverts to default behavior in setting that attribute' do
          expect(mastermind_with_empty_params.code_elements).to eq @default_code_elements
          expect(mastermind_with_empty_params.code_length).to eq @default_code_length
          expect(mastermind_with_empty_params.max_turns).to eq @default_max_turns
        end
      end
    end
  end

  describe '#code_valid?' do

    it 'returns true if the given code is the correct length and each of the elements are valid' do
      expect(mastermind.code_valid?(example_code)).to be true
    end

    it 'returns false if code is an incorrect length' do
      too_short_code = Array.new(
        @default_code_length - 1, @default_code_elements.sample
      )
      too_long_code = Array.new(
        @default_code_length + 1, @default_code_elements.sample
      )

      expect(mastermind.code_valid?(too_short_code)).to be false
      expect(mastermind.code_valid?(too_long_code)).to be false
    end

    it 'returns false if any of the given code\'s elements are invalid' do
      invalid_elements_code = Array.new(@default_code_length, :foo)
      expect(mastermind.code_valid?(invalid_elements_code)).to be false
    end
  end

  describe '#code_guessed?' do

    it 'returns true if given feedback has all matches, indicating the code was sucessfully guessed' do
      correct_guess_feedback = {match: @default_code_length, close: 0, miss: 0}
      expect(mastermind.code_guessed?(correct_guess_feedback)).to be true
    end

    it 'returns false if given feedback that is not all matches' do
      incorrect_guess_feedback = {match: 1, close: 3, miss: 0}
      expect(mastermind.code_guessed?(incorrect_guess_feedback)).to be false
    end
  end
end
