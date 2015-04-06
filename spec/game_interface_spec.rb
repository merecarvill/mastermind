require 'spec_helper'

describe GameInterface do
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
  let(:example_code_input) { "blue blue red green" }
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

    it 'prints the game instructions' do
      expect($stdout.string).not_to eq ""
      expect($stdout.string.downcase.include?("instructions")).to be true
    end

    it 'includes the guess elements in the instructions' do
      expect($stdout.string.include?(default[:code_elements].join(", "))).to be true
    end

    it 'includes the code length in the instructions' do
      expect($stdout.string.include?(default[:code_length].to_s)).to be true
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
    before do
      interface.display_guess(example_code)
    end

    it 'prints a given guess, including all guess elements' do
      expect($stdout.string).not_to eq ""
      example_code.each do |element|
        expect($stdout.string.include?(element.to_s)).to be true
      end
    end

    it 'at least mentions "computer" and "guess"' do
      expect($stdout.string.include?("computer")).to be true
      expect($stdout.string.include?("guess")).to be true
    end
  end

  describe '#display_code_reminder' do
    before do
      interface.display_code_reminder(example_code)
    end

    it 'prints a reminder of the given secret code, including all code elements' do
      expect($stdout.string).not_to eq ""
      example_code.each do |element|
        expect($stdout.string.include?(element.to_s)).to be true
      end
    end

    it 'at least mentions "your" and "code"' do
      expect($stdout.string.include?("your")).to be true
      expect($stdout.string.include?("code")).to be true
    end
  end

  describe '#solicit_feedback' do
    let(:example_feedback) { {match: 1, close: 3, miss: 0} }
    let(:example_feedback_input) { ["1 match", "3close", "0"] }

    it 'prints a message soliciting feedback on a guess' do
      allow($stdin).to receive(:gets) { example_feedback_input.shift }
      interface.solicit_feedback
      expect($stdout.string).not_to eq ""
    end

    it 'returns a feedback hash made from string input by the player' do
      allow($stdin).to receive(:gets) { example_feedback_input.shift }
      expect(interface.solicit_feedback).to eq example_feedback
    end
  end

  describe '#solicit_feedback_aspect' do

    it 'prints a prompt asking player to input the given aspect of feedback' do
      allow($stdin).to receive(:gets) { "2" }

      interface.solicit_feedback_aspect(:foo)
      expect($stdout.string).not_to eq ""
    end

    it 'specifies the aspect solicited in the message' do
      allow($stdin).to receive(:gets) { "2" }

      interface.solicit_feedback_aspect(:match)
      expect($stdout.string.include?("match")).to be true
      $stdout.flush

      interface.solicit_feedback_aspect(:close)
      expect($stdout.string.include?("close")).to be true
      $stdout.flush

      interface.solicit_feedback_aspect(:miss)
      expect($stdout.string.include?("miss")).to be true
    end

    it 'returns player input in integer form' do
      allow($stdin).to receive(:gets) { "2" }

      player_input = interface.solicit_feedback_aspect(:foo)
      expect(player_input).to eq 2
    end

    it 'returns the numerical component as an integer if player input begins with a number' do
      allow($stdin).to receive(:gets) { "2 matches" }

      player_input = interface.solicit_feedback_aspect(:foo)
      expect(player_input).to eq 2
    end

    it 'returns the integer 0 when player input does not begin with a numerical element' do
      allow($stdin).to receive(:gets) { "f8" }

      player_input = interface.solicit_feedback_aspect(:foo)
      expect(player_input).to eq 0
    end
  end

  describe '#display_code_maker_won' do
    before do
      interface.display_code_maker_won
    end

    it 'prints a message telling the player they won' do
      expect($stdout.string).not_to eq ""
    end

    it 'at least mentions "you" and "won"' do
      expect($stdout.string.include?("you")).to be true
      expect($stdout.string.include?("win")).to be true
    end
  end

  describe '#display_code_maker_lost' do
    before do
      interface.display_code_maker_lost
    end

    it 'prints a message telling the player they lost' do
      expect($stdout.string).not_to eq ""
    end

    it 'at least mentions "you" and "lose"' do
      expect($stdout.string.include?("you")).to be true
      expect($stdout.string.include?("lose")).to be true
    end
  end
end