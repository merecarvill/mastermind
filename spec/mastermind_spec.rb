require 'spec_helper'

describe Mastermind do
  include_context 'default_values'

  before :all do
    @input_stream = StringIO.new
    @output_stream = StringIO.new
  end

  after do
    @input_stream.string = ""
    @output_stream.string = ""
  end
  
  let(:example_code) { [:blue, :blue, :red, :green] }
  let(:testing_interface) { 
    MastermindInterface.new(@default_code_elements, @default_code_length, @input_stream, @output_stream)
  }
  let(:mastermind) { build(:mastermind, interface: testing_interface) }

  describe '#initialize' do

    it 'returns an object of type Mastermind' do
      expect(mastermind).to be_a Mastermind
    end

    it 'makes a MastermindAI and stores it in an instance variable' do
      expect(mastermind.ai).to be_a MastermindAI
    end

    it 'makes a MastermindInterface and stores it in an instance variable' do
      expect(mastermind.interface).to be_a MastermindInterface
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

      it 'sets code elements, code length, max turns to specified values' do
        expect(mastermind_with_params.code_elements).to eq params[:code_elements]
        expect(mastermind_with_params.code_length).to eq params[:code_length]
        expect(mastermind_with_params.max_turns).to eq params[:max_turns]
      end

      context 'when any given attribute is not specified in parameters' do
        let(:mastermind_with_empty_params) { Mastermind.new(Hash.new) }

        it 'reverts to default behavior in setting that attribute' do
          expect(mastermind_with_empty_params.code_elements).to eq @default_code_elements
          expect(mastermind_with_empty_params.code_length).to eq @default_code_length
          expect(mastermind_with_empty_params.max_turns).to eq @default_max_turns
        end
      end
    end
  end

  describe '#get_valid_feedback_for_guess' do
    let(:mastermind) { 
      build(:mastermind, interface: testing_interface, guess_checker: GuessChecker.new(example_code)) 
    }
    let(:guess) { example_code.map{ @default_code_elements.sample } }
    let(:feedback) { mastermind.guess_checker.compare_to_code(guess) }

    context 'when player input is the correct feedback for given guess' do
      let(:correct_feedback_input) { feedback.map{ |key, value| value.to_s } }
      before do
        @input_stream.string = correct_feedback_input.join("\n")
      end

      it 'has the interface prompt the player for feedback' do
        mastermind.get_valid_feedback_for_guess(guess)
        expect(@output_stream.string).not_to eq ""
      end

      it 'accepts input from the player returns it as feedback in the proper form' do
        expect(mastermind.get_valid_feedback_for_guess(guess)).to eq feedback
      end
    end

    context 'when player input is not initially the correct feedback for given guess' do
      let(:incorrect_input_followed_by_valid_feedback_input) { 
        ["this is", "one set of", "invalid input"] + feedback.map{ |key, value| value.to_s } 
      }
      before do
        @input_stream.string = incorrect_input_followed_by_valid_feedback_input.join("\n")
      end

      it 'has the interface repeat the prompt until player inputs correct feedback' do
        mastermind.get_valid_feedback_for_guess(guess)

        interface_output_lines = @output_stream.string.split("\n")
        output_has_repeated_lines = interface_output_lines.uniq.length != interface_output_lines.length

        expect(output_has_repeated_lines).to be true
      end
    end
  end

  describe '#code_valid?' do

    it 'returns false if code is an incorrect length' do
      too_short_code = Array.new(@default_code_length - 1, @default_code_elements.sample)
      too_long_code = Array.new(@default_code_length + 1, @default_code_elements.sample)

      expect(mastermind.code_valid?(too_short_code)).to be false
      expect(mastermind.code_valid?(too_long_code)).to be false
    end

    it 'returns false if given code has invalid elements' do
      invalid_elements_code = Array.new(@default_code_length, :foo)
      expect(mastermind.code_valid?(invalid_elements_code)).to be false
    end

    it 'returns true if the given code is the correct length and each of the elements are valid' do
      expect(mastermind.code_valid?(example_code)).to be true
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
