require 'spec_helper'

describe Array do
  let(:example_array) { [1, 1, 2, 3] }

  describe '#frequencies' do

    it 'returns a hash of each element to the number of times it occurs in array' do
      array = [:foo, :bar, :foo]
      output_hash = {foo: 2, bar: 1}
      expect(array.frequencies).to eq output_hash
    end
  end

  describe '#delete_first' do

    context 'if given item is in array' do

      it 'deletes the first occurrence of given item from array' do
        example_array.delete_first(1)
        expect(example_array).to eq [1, 2, 3]
      end

      it 'returns the deleted item' do
        expect(example_array.delete_first(1)).to eq 1
      end
    end

    context 'if given item is not in array' do

      it 'returns nil' do
        expect(example_array.delete_first(0)).to be nil
      end
    end
  end

  describe '#delete_first_for_each_in' do

    it 'for every item in given array, deletes the first occurrence from target array' do
      example_array.delete_first_for_each_in([1, 2, 3])
      expect(example_array).to eq [1]
    end

    it 'does nothing for items in given array that are not present in target array' do
      example_array.delete_first_for_each_in([:not, :elements, :in, :the, :array])
      expect(example_array).to eq example_array
    end
  end
end