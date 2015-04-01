require 'spec_helper'

describe Mastermind do
  let!(:mastermind) { build(:mastermind) }
  let(:code_length) { 4 }
  let(:guessable_colors) { [:red, :green, :orange, :yellow, :blue, :purple] }

  describe '#initialize' do

    it 'returns an object of type Mastermind' do
      expect(mastermind).to be_a Mastermind
    end
  end

  describe '#guessable_colors' do

    it 'returns an array of symbols enumerating the guessable colors within games' do
      expect(mastermind.guessable_colors).to eq guessable_colors
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

  describe '#new_game' do

    it 'takes no perameters' do
      expect{mastermind.new_game}.not_to raise_error
    end
  end

  describe '#generate_code' do
    let(:generated_code) { mastermind.generate_code(code_length) }

    it 'takes the desired length of the code' do
      expect{generated_code}.not_to raise_error
    end

    it 'returns an array of the input length' do
      expect(generated_code.length).to eq code_length
    end

    it 'returns an array containing only colors that are guessable colors' do
      generated_code.uniq.each do |color|
        expect(mastermind.guessable_color?(color)).to eq true
      end
    end
  end
end
