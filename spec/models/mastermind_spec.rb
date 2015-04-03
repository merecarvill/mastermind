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
end
