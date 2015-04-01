require 'spec_helper'

describe MastermindAI do
  let(:ai) { MastermindAI.new }
  let(:example_feedback) { {match: 1, close: 1, miss: 2} }

  describe '#initialize' do

    it 'returns an object of type MastermindAI' do
      expect(ai).to be_a MastermindAI
    end
  end

  describe '#get_feedback' do

    it 'takes a hash containing feedback on a guess made' do
      expect{ai.get_feedback(example_feedback)}.not_to raise_error
    end
  end
end