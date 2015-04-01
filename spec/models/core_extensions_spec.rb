require 'spec_helper'

describe Array do

  describe '#frequencies' do
    it 'returns a hash of each element to the number of times it occurs in array' do
      array = [:foo, :bar, :foo]
      output_hash = {foo: 2, bar: 1}
      expect(array.frequencies).to eq output_hash
    end
  end
end