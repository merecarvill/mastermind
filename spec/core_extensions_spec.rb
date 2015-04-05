require 'spec_helper'

describe Array do
  let(:example_array) { [1, 1, 2, 3] }

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

  describe '#subtract_one_for_one' do

    it 'returns a new array with every element from given array removed from the original one-for-one' do
      new_array = example_array.subtract_one_for_one([1, 2, 3])
      expect(new_array).to eq [1]
    end

    it 'ignores items in given array that are not present in original array' do
      new_array = example_array.subtract_one_for_one([:not, :elements, :in, :the, :array])
      expect(new_array).to eq example_array
    end
  end
end