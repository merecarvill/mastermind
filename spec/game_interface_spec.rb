require 'spec_helper'

describe GameInterface do
  before do
    $stdout = StringIO.new
  end

  after :all do
    $stdout = STDOUT
  end

  let(:default) { {
    code_elements: [:red, :green, :orange, :yellow, :blue, :purple],
    code_length: 4,
    max_turns: 10,
  } }
  let(:example_code) { [:blue, :blue, :red, :green] }
  let(:example_code_input) { "blue blue red green" }
  let(:example_feedback) { {match: 1, close: 3, miss: 0} }
  let(:example_feedback_input) { "1 3 0" }
  let(:interface) { GameInterface.new(default[:code_elements], default[:code_length]) }

  describe '#initialize' do

    it 'takes a game\'s guess elements and code length' do
      expect{interface}.not_to raise_error
    end

    it 'returns an object of type GameInterface' do
      expect(interface).to be_a GameInterface
    end
  end

  describe '#display_instructions' do
    before do
      interface.display_instructions
    end

    it 'prints instructions' do
      expect($stdout.string).not_to eq ""
    end

    it 'includes the guess elements in the instructions' do
      expect($stdout.string.include?(default[:code_elements].join(", "))).to eq true
    end

    it 'includes the code length in the instructions' do
      expect($stdout.string.include?(default[:code_length].to_s)).to eq true
    end
  end

  describe '#solicit_code' do

    it 'prints a message soliciting the player\'s secret code' do
      allow($stdin).to receive(:gets) { example_code_input }
      interface.solicit_code
      expect($stdout.string).not_to eq ""
    end

    it 'returns the code given by the player' do
      allow($stdin).to receive(:gets) { example_code_input }
      expect(interface.solicit_code).to eq example_code
    end
  end

  describe '#display_guess' do

    it 'prints a given guess, including mention of "guess" and "computer"' do
      interface.display_guess(example_code)
      expect($stdout.string).not_to eq ""
      expect($stdout.string.include?("computer")).to be true
      expect($stdout.string.include?("guess")).to be true
      example_code.each do |element|
        expect($stdout.string.include?(element.to_s)).to be true
      end
    end
  end

  describe '#display_code_reminder' do

    it 'prints a reminder of the given secret code, including mention of "your" and "code"' do
      interface.display_code_reminder(example_code)
      expect($stdout.string).not_to eq ""
      expect($stdout.string.include?("your")).to be true
      expect($stdout.string.include?("code")).to be true
      example_code.each do |element|
        expect($stdout.string.include?(element.to_s)).to be true
      end
    end
  end

  describe '#solicit_feedback' do

    it 'prints a message soliciting feedback on a guess' do
      allow($stdin).to receive(:gets) { example_feedback_input }
      interface.solicit_feedback
      expect($stdout.string).not_to eq ""
    end

    it 'returns a feedback hash made from string input by the player' do
      allow($stdin).to receive(:gets) { example_feedback_input }
      expect(interface.solicit_feedback).to eq example_feedback
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