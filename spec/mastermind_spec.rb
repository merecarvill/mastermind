require 'spec_helper'

describe Mastermind do
  let(:default) { {
    guess_elements: [:red, :green, :orange, :yellow, :blue, :purple],
    code_length: 4,
    max_turns: 10,
  } }
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

      it 'sets guess elements, max turns, code length to default values' do
        expect(mastermind.guess_elements).to eq default[:guess_elements]
        expect(mastermind.code_length).to eq default[:code_length]
        expect(mastermind.max_turns).to eq default[:max_turns]
      end
    end

    context 'when given parameters' do
      let(:params) { {
        guess_elements: [1, 2, 3],
        code_length: 5,
        max_turns: 8,
      } }
      let(:mastermind_with_params) { Mastermind.new(params) }
      let(:mastermind_with_empty_params) { Mastermind.new(Hash.new) }

      it 'sets guess elements, max turns, code length, and secret code to specified values' do
        expect(mastermind_with_params.guess_elements).to eq params[:guess_elements]
        expect(mastermind_with_params.code_length).to eq params[:code_length]
        expect(mastermind_with_params.max_turns).to eq params[:max_turns]
      end

      context 'when any given attribute is not specified in parameters' do

        it 'reverts to default behavior in setting that attribute' do
          expect(mastermind_with_empty_params.guess_elements).to eq default[:guess_elements]
          expect(mastermind_with_empty_params.code_length).to eq default[:code_length]
          expect(mastermind_with_empty_params.max_turns).to eq default[:max_turns]
        end
      end
    end
  end

  describe '#code_valid?' do

    it 'checks if each of the given code\'s elements are valid' do
      invalid_elements_code = Array.new(default[:code_length], :foo)

      expect(mastermind.code_valid?(example_code)).to eq true
      expect(mastermind.code_valid?(invalid_elements_code)).to eq false
    end

    it 'checks if code is the correct length' do
      invalid_length_code = Array.new(
        default[:code_length] - 1, default[:guess_elements].sample
      )

      expect(mastermind.code_valid?(example_code)).to eq true
      expect(mastermind.code_valid?(invalid_length_code)).to eq false
    end
  end
end
