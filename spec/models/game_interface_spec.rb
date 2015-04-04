require 'spec_helper'

describe GameInterface do
  before do
    $stdout = StringIO.new
  end

  after :all do
    $stdout = STDOUT
  end

  let(:default) { {
    guess_elements: [:red, :green, :orange, :yellow, :blue, :purple],
    code_length: 4,
    max_turns: 10,
  } }
  let(:example_code) { [:blue, :blue, :red, :green] }
  let(:interface) { GameInterface.new }

  describe '#display_instructions' do
    before do
      interface.display_instructions(default[:code_length], default[:guess_elements])
    end

    it 'prints instructions' do
      expect($stdout.string).not_to eq ""
    end

    it 'includes the guess elements in the instructions' do
      expect($stdout.string.include?(default[:guess_elements].to_s)).to eq true
    end

    it 'includes the code length in the instructions' do
      expect($stdout.string.include?(default[:code_length].to_s)).to eq true
    end
  end

  describe '#solicit_code' do

    it 'prints a message soliciting the player\'s secret code' do
      allow($stdin).to receive(:gets) { "blue blue red green" }
      interface.solicit_code
      expect($stdout.string).not_to eq ""
    end

    it 'returns the code given by the player' do
      allow($stdin).to receive(:gets) { "blue blue red green" }
      expect(interface.solicit_code).to eq example_code
    end
  end

  describe '#display_guess' do

    it 'prints a given guess' do
      interface.display_guess(example_code)
      expect($stdout.string).not_to eq ""
      example_code.each do |element|
        expect($stdout.string.include?(element.to_s)).to eq true
      end
    end
  end

  describe '#solicit_feedback' do

    it 'prints a message soliciting feedback on a guess' do
      allow($stdin).to receive(:gets) { "1 3 0" }
      interface.solicit_feedback
      expect($stdout.string).not_to eq ""
    end

    it 'returns a feedback hash made from string input by the player' do
      feedback = {match: 1, close: 3, miss: 0}

      allow($stdin).to receive(:gets) { "1 3 0" }
      expect(interface.solicit_feedback).to eq feedback
    end
  end

  describe '#display_code_maker_won' do

    it 'prints a message telling the player they won' do
      interface.display_code_maker_won
      expect($stdout.string).not_to eq ""
    end
  end

  describe '#display_code_maker_lost' do

    it 'prints a message telling the player they lost' do
      interface.display_code_maker_lost
      expect($stdout.string).not_to eq ""
    end
  end
end