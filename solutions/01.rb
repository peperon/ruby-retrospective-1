class Array
  def to_hash
    inject({}) do |result, pair|
      result[pair[0]] = pair[1]
      result
    end
  end
  
  def index_by
    map { |index| [yield(index), index] }.to_hash
  end
  
  def subarray_count(array)
    each_cons(array.length).count(array)
  end
  
  def occurences_count
    Hash.new(0).merge map { |element| [element, count(element)] }.to_hash
  end
end