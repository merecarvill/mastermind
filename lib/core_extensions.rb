class Array

  def frequencies
    self.each_with_object(Hash.new(0)){ |key,hash| hash[key] += 1 }
  end

  def delete_first(item)
    self.delete_at(self.index(item) || self.length)
  end

  def delete_first_for_each_in(array)
    array.each do |item|
      self.delete_first(item)
    end
  end
end