require 'spec_helper'

describe MastermindAITester do
  include_context 'default_values' 

  let(:tester) { MastermindAITester.new(@default_code_elements, @default_code_length) }

  describe '#initialize' do

    it 'takes the set of potential elements in a code and the code length' do
      expect{tester}.not_to raise_error
    end

    it 'returns an object of type MastermindAITester' do
      expect(tester).to be_a MastermindAITester
    end
  end

  describe '#run_tests' do
    let(:num_tests) { 10 }
    before do
      allow($stdout).to receive(:puts) { true }
    end

    it 'runs the given number of tests on the ai' do
      test_counter = 0
      allow(tester).to receive(:run_one_test) do
        test_counter += 1
      end
      tester.run_tests(num_tests)

      expect(test_counter).to eq num_tests
    end

    it 'prints statistics about the tests to the command line' do
      printed_to_command_line = tester.run_tests(num_tests)
      expect(printed_to_command_line).to be true
    end
  end

  describe '#calculate_stats' do
    let(:example_data) { [1, 1, 2, 2, 3, 3] }

    it 'returns the average, max, and percent occurrance of max number in given array' do
      avg, max, percent_max = tester.calculate_stats(example_data)
      expect(avg).to eq example_data.reduce(:+).to_f / example_data.length
      expect(max).to eq example_data.max
      expect(percent_max).to be_within(0.1).of(example_data.count(max).to_f / example_data.length * 100)
    end
  end

  describe '#run_one_test' do
    let(:ai) { MastermindAI.new(@default_code_elements, @default_code_length) }

    it 'returns the number of turns taken for given MastermindAI to guess a random secret code' do
      expect(tester.run_one_test(ai)).to be_an Integer
      expect(ai.last_feedback_received[:match]).to eq @default_code_length
    end
  end

  describe '#generate_code' do

    it 'generates a code from the code elements, with duplicate elements allowed' do
      tester.generate_code.each do |element|
        expect(@default_code_elements.include?(element)).to be true
      end
    end

    it 'generates a code of the correct length' do
      expect(tester.generate_code.length).to eq @default_code_length
    end
  end
end