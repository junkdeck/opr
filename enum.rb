module Enumerable
  def j_each
    for x in self do
      yield(x)
    end
  end
  def j_each_index
    i = 0
    self.j_each do |x|
      yield(x, i)
      i += 1
    end
  end
  def j_select
    true_values_from_self = []
    self.j_each do |x|
      return_from_yield = yield(x)
      true_values_from_self << x if return_from_yield == true
    end
    return true_values_from_self
  end
end
