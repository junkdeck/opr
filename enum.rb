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
  def j_count(item=true)
    # counts the amount of items in a list. counts all items if no argument or block is provided.
    # increments if argument supplied matches the item, or if the expression in a block evaluates as true
    i = 0   # increment counter
    self.j_each do |x|
      # "ignores" the item to check for - used for the if statement beneath
      item = false if block_given?
      # stores the return value from a supplied block, but only if a block is actually supplied
      yield_return = yield(x) if block_given?
      if item == true || yield_return
        # increments by one if no arguments supplied, or if a block was supplied.
        # if neither block or argument was supplied, the "item" remains true and ticks the incrementer
        i += 1
      else
        # if we're here, it's because we've supplied an argument - only increment if the current item from the array is equal to that value
        i += 1 if item == x
      end
    end
    return i
  end
end
