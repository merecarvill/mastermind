require 'spec_helper'

describe GameInterface do
  include_context 'default_values'

  let(:example_code) { [:blue, :blue, :red, :green] }
  let(:example_code_input) { "blue blue red green" }

  before :all do
    @input_stream = StringIO.new
    @output_stream = StringIO.new
    @interface = GameInterface.new(@default_code_elements, @default_code_length, @input_stream, @output_stream)
  end

  after do
    @input_stream.string = ""
    @output_stream.string = ""
  end

  describe '#initialize' do

    it 'returns an object of type GameInterface' do
      expect(@interface).to be_a GameInterface
    end
  end

  describe '#display_instructions' do
    before do
      @interface.display_instructions
    end

    it 'prints the game instructions' do
      expect(@output_stream.string).to eq @interface.text_for(:display_instructions)
    end
  end

  describe '#solicit_code' do
    before do
      @input_stream.string = example_code_input
    end

    it 'prints a message soliciting the player\'s secret code' do
      @interface.solicit_code
      expect(@output_stream.string).to eq @interface.text_for(:solicit_code)
    end

    it 'returns the code given by the player' do
      expect(@interface.solicit_code).to eq example_code
    end
  end

  describe '#display_guess' do
    before do
      @interface.display_guess(example_code)
    end

    it 'prints a given guess, including all guess elements' do
      expect(@output_stream.string).not_to eq ""
      example_code.each do |element|
        expect(@output_stream.string.include?(element.to_s)).to be true
      end
    end

    it 'at least mentions "computer" and "guess"' do
      expect(@output_stream.string.include?("computer")).to be true
      expect(@output_stream.string.include?("guess")).to be true
    end
  end

  describe '#display_code_reminder' do
    before do
      @interface.display_code_reminder(example_code)
    end

    it 'prints a reminder of the given secret code, including all code elements' do
      expect(@output_stream.string.start_with?(@interface.text_for(:display_code_reminder))).to be true
      example_code.each do |element|
        expect(@output_stream.string.include?(element.to_s)).to be true
      end
    end
  end

  describe '#solicit_feedback' do
    let(:example_feedback) { {match: 1, close: 3, miss: 0} }
    let(:example_feedback_input) { ["1 match ", "3close!", "0"] }
    before do
      @input_stream.string = example_feedback_input.join("\n")
    end

    it 'prints a message soliciting feedback on a guess' do
      @interface.solicit_feedback
      expect(@output_stream.string.start_with?(@interface.text_for(:solicit_feedback))).to be true
    end

    it 'returns a feedback hash made from string input by the player' do
      expect(@interface.solicit_feedback).to eq example_feedback
    end
  end

  describe '#solicit_feedback_aspect' do
    let(:aspects) { [:match, :close, :miss] }

    it 'prints a prompt asking player to input the given aspect of feedback' do
      @input_stream.string = "2"

      @interface.solicit_feedback_aspect(:foo)
      expect(@output_stream.string).not_to eq ""
    end

    it 'specifies the aspect solicited in the message' do
      aspects.each do |aspect|
        @input_stream.string = "2"
        @interface.solicit_feedback_aspect(aspect)
        expect(@output_stream.string.include?(aspect.to_s)).to be true
        @output_stream.flush
      end
    end

    it 'returns player input in integer form' do
      @input_stream.string = "2"

      player_input = @interface.solicit_feedback_aspect(:foo)
      expect(player_input).to eq 2
    end

    it 'returns the numerical component as an integer if player input begins with a number' do
      @input_stream.string = "2 matches"

      player_input = @interface.solicit_feedback_aspect(:foo)
      expect(player_input).to eq 2
    end

    it 'returns the integer 0 when player input does not begin with a numerical element' do
      @input_stream.string = "f8"

      player_input = @interface.solicit_feedback_aspect(:foo)
      expect(player_input).to eq 0
    end
  end

  describe '#display_code_maker_won' do
    before do
      @interface.display_code_maker_won
    end

    it 'prints a message telling the player they won' do
      expect(@output_stream.string).to eq @interface.text_for(:display_code_maker_won)
    end
  end

  describe '#display_code_maker_lost' do
    before do
      @interface.display_code_maker_lost
    end

    it 'prints a message telling the player they lost' do
      expect(@output_stream.string).to eq @interface.text_for(:display_code_maker_lost)
    end
  end
end