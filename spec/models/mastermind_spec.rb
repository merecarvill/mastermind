require 'spec_helper'

describe Mastermind do

  describe '#initialize' do
    let!(:mastermind) { build(:mastermind) }

    it "returns an object of type Mastermind" do
      expect(mastermind).to be_a Mastermind
    end
  end
end
