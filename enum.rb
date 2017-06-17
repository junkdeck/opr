module Enumerable
  def j_each
    for x in self do
      yield(x)
    end
    return self
  end
  def j_each_index
    i = 0
    self.j_each do |x|
      yield(x, i)
      i += 1
    end
    return self
  end
  def j_select
    true_values_from_self = []
    self.j_each do |x|
      true_values_from_self << x if yield(x) == true
    end
    return true_values_from_self
  end
  def j_all?
    # first false returns false
    first_false = true
    self.j_each do |x|
      first_false = false if yield(x) == false
    end
    return first_false
  end
  def j_any?
    # first true returns true
    first_true = false
    self.j_each do |x|
      first_true = true if yield(x) == true
    end
    return first_true
  end
  def j_none?
    none = self.j_any? do |x|
      yield(x)
    end
    none = !none
  end
end
