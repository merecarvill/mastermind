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

    it 'makes a GuessChecker' do
      expect(mastermind.guess_checker).to be_a GuessChecker
    end

    context 'when no parameters are given' do

      it 'sets guess elements, max turns, code length to default values' do
        expect(mastermind.guess_elements).to eq default[:guess_elements]
        expect(mastermind.code_length).to eq default[:code_length]
        expect(mastermind.max_turns).to eq default[:max_turns]
      end

      it 'generates a random secret code' do
        expect(mastermind.secret_code).not_to eq Mastermind.new.secret_code
      end
    end

    context 'when given parameters' do
      let(:params) { {
        guess_elements: [1, 2, 3],
        code_length: 5,
        max_turns: 8,
        secret_code: [1, 1, 3, 2, 1],
      } }
      let(:mastermind_with_params) { Mastermind.new(params) }
      let(:mastermind_with_empty_params) { Mastermind.new(Hash.new) }

      it 'sets guess elements, max turns, code length, and secret code to specified values' do
        expect(mastermind_with_params.guess_elements).to eq params[:guess_elements]
        expect(mastermind_with_params.code_length).to eq params[:code_length]
        expect(mastermind_with_params.max_turns).to eq params[:max_turns]
        expect(mastermind_with_params.secret_code).to eq params[:secret_code]
      end

      context 'when any attribute is not specified in parameters' do

        it 'reverts to default value for that attribute' do
          expect(mastermind_with_empty_params.guess_elements).to eq default[:guess_elements]
          expect(mastermind_with_empty_params.code_length).to eq default[:code_length]
          expect(mastermind_with_empty_params.max_turns).to eq default[:max_turns]
          expect(mastermind_with_empty_params.secret_code).not_to eq Mastermind.new.secret_code
        end
      end
    end
  end

  describe '#new_game' do
    before do
      $stdout = StringIO.new
    end

    after :all do
      $stdout = STDOUT
    end

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
end
