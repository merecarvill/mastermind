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

  describe '#set_up_game' do
    let(:valid_code) { generate_random_code }
    before do
      allow(mastermind.interface).to receive(:clear_screen)
      @input_stream.string = valid_code.join(" ")
      mastermind.set_up_game
    end

    it 'displays the game instructions and a prompt for a secret code from player' do
      expect(@output_stream.string).not_to eq ""
    end

    it 'initializes a GuessChecker whose code equals the code input by the player' do
      expect(mastermind.guess_checker.code).to eq valid_code
    end
  end

  describe '#init_guess_checker_with_valid_code_from_player' do
    let(:valid_code) { generate_random_code }

    context 'when given valid input by player' do
      before do
        @input_stream.string = valid_code.join(" ")
        mastermind.init_guess_checker_with_valid_code_from_player
      end

      it 'prompts the player for a code to be used as the secret code' do
        expect(@output_stream.string).not_to eq ""
      end

      it 'initializes a GuessChecker with the input code and stores it in an instance variable' do
        expect(mastermind.guess_checker.code).to eq valid_code
      end
    end

    context 'when initially given invalid input by player' do
      before do
        @input_stream.string = "this is invalid input\n" + valid_code.join(" ")
        mastermind.init_guess_checker_with_valid_code_from_player
      end

      it 'repeats the prompt until it recieves a valid code' do
        expect(has_at_least_one_repeated_line?(@output_stream.string)).to be true
      end
    end
  end

  describe '#run_game' do
    let(:mastermind) { 
      build(:mastermind, interface: testing_interface) 
    }
    let(:non_winning_feedback) { {match: @default_code_length - 1, close: 1, miss: 0} }
    let(:winning_feedback) { {match: @default_code_length, close: 0, miss: 0} }
    let(:arbitrary_winning_turn) { rand(@default_max_turns) + 1 }
    before do
      allow(mastermind.interface).to receive(:clear_screen)
      mastermind.ai.last_feedback_received = non_winning_feedback
      @turn_counter = 0
    end

    context 'when computer successfully guesses the secret code' do
      before do
        allow(mastermind).to receive(:handle_one_turn) do
          @turn_counter += 1
          if @turn_counter == arbitrary_winning_turn
            mastermind.ai.last_feedback_received = winning_feedback
          end
        end
        mastermind.run_game
      end

      it 'ceases executing turns after the code is guessed' do
        expect(@turn_counter).to eq arbitrary_winning_turn
      end

      it 'displays a message telling the player they lost' do
        last_output_line = @output_stream.string.split("\n").last
        mentions_loss = last_output_line.include?("lose") || last_output_line.include?("lost")

        expect(mentions_loss).to be true
      end
    end

    context 'when computer does not guess the secret code' do
      before do
        allow(mastermind).to receive(:handle_one_turn) do
          @turn_counter += 1
        end
        mastermind.run_game
      end

      it 'executes a number of turns equal to the max turns of the game' do
        expect(@turn_counter).to eq @default_max_turns
      end

      it 'displays a message telling the player they won' do
        last_output_line = @output_stream.string.split("\n").last
        mentions_win = last_output_line.include?("win") || last_output_line.include?("won")

        expect(mentions_win).to be true
      end
    end
  end

  describe '#handle_one_turn' do
    let(:mastermind) { 
      build(:mastermind, interface: testing_interface, guess_checker: GuessChecker.new(generate_random_code)) 
    }
    let(:ai_guess) { generate_random_code }
    let(:feedback) { mastermind.guess_checker.compare_to_code(ai_guess) }
    let(:feedback_inputs) { feedback.map{ |key, value| value.to_s } }
    before do
      allow(mastermind.ai).to receive(:make_guess).and_return(ai_guess)
      mastermind.ai.last_guess_made = ai_guess

      @input_stream.string = feedback_inputs.join("\n")
    end

    it 'displays a guess made by the game ai' do
      mastermind.handle_one_turn
      ai_guess.each do |element|
        expect(@output_stream.string.include?(element.to_s)).to be true
      end
    end

    it 'accepts feedback on the guess from the player and passes it to the game ai' do
      expect(mastermind.ai).to receive(:receive_feedback) { feedback }
      mastermind.handle_one_turn
    end
  end

  describe '#display_guess_with_secret_code_reminder' do
    let(:mastermind) { 
      build(:mastermind, interface: testing_interface, guess_checker: GuessChecker.new(generate_random_code)) 
    }
    let(:guess) { generate_random_code }
    before do
      mastermind.display_guess_with_secret_code_reminder(guess)
    end

    it 'displays the given guess' do
      guess.each do |element|
        expect(@output_stream.string.include?(element.to_s))
      end
    end

    it 'displays the game\'s secret code' do
      mastermind.guess_checker.code.each do |element|
        expect(@output_stream.string.include?(element.to_s))
      end
    end
  end

  describe '#get_correct_feedback_from_player' do
    let(:mastermind) { 
      build(:mastermind, interface: testing_interface, guess_checker: GuessChecker.new(generate_random_code)) 
    }
    let(:correct_feedback) { mastermind.guess_checker.compare_to_code(generate_random_code) }
    let(:correct_feedback_inputs) { correct_feedback.map{ |key, value| value.to_s } }
    before do
        @input_stream.string = correct_feedback_inputs.join("\n")
    end

    it 'prompts the player for feedback' do
      mastermind.get_correct_feedback_from_player(correct_feedback)
      expect(@output_stream.string).not_to eq ""
    end

    context 'when player input results in feedback equal to given comparison feedback' do

      it 'accepts input feedback from the player and returns it as data' do
        expect(mastermind.get_correct_feedback_from_player(correct_feedback)).to eq correct_feedback
      end
    end

    context 'when initial player input does not result in feedback equal to given comparison feedback' do
      let(:incorrect_inputs_followed_by_correct_feedback_inputs) { 
        ["this is one", "set of three", "invalid inputs"] + correct_feedback.map{ |key, value| value.to_s } 
      }
      before do
        @input_stream.string = incorrect_inputs_followed_by_correct_feedback_inputs.join("\n")
      end

      it 'repeats the prompt until player inputs correct feedback' do
        mastermind.get_correct_feedback_from_player(correct_feedback)

        expect(has_at_least_one_repeated_line?(@output_stream.string)).to be true
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
      expect(mastermind.code_valid?(generate_random_code)).to be true
    end
  end

  describe '#code_guessed?' do

    it 'returns true if, in given feedback, number of matches equals code length' do
      correct_guess_feedback = {match: @default_code_length, close: 0, miss: 0}
      expect(mastermind.code_guessed?(correct_guess_feedback)).to be true
    end

    it 'returns false if, in given feedback, number of matches does not equal the code length' do
      incorrect_guess_feedback = {match: 1, close: 3, miss: 0}
      expect(mastermind.code_guessed?(incorrect_guess_feedback)).to be false
    end
  end
end
