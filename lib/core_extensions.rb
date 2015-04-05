class Array

  def delete_first(item)
    self.delete_at(self.index(item) || self.length)
  end

  def subtract_one_for_one(array)
    new_array = self.dup
    array.each_with_object(new_array) do |item|
      new_array.delete_first(item)
    end
  end
end