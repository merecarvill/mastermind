require 'spec_helper'

describe MastermindAI do
  let(:ai) { MastermindAI.new }
  let(:feedback_types) { [:match, :close, :miss] }
  let(:example_feedback) { {match: 1, close: 1, miss: 2} }

  describe '#initialize' do

    it 'returns an object of type MastermindAI' do
      expect(ai).to be_a MastermindAI
    end
  end

  describe '#feedback_history' do

    it 'returns an array of hashes, each containing feedback for one guess' do
      expect(ai.feedback_history).to be_a Array
      ai.feedback_history.each do |feedback|
        feedback_types.each do |type|
          expect(feedback.has_key?(type)).to be true
        end
      end
    end
  end

  describe '#store_feedback' do

    it 'takes a hash containing feedback on a guess' do
      expect{ai.store_feedback(example_feedback)}.not_to raise_error
    end

    it 'adds the hash to those stored in @feedback_history' do
      ai.store_feedback(example_feedback)
      expect(ai.feedback_history.include?(example_feedback)).to eq true
    end
  end
end