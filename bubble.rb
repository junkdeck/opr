def bubble_sort(arr)
  # terribly written code, so let me comment on this
  i = 0   # increment var
  swapped = false   # keeps track of swaps
  loop do
    # only performs the swapping action up to the last item of the array
    if i < arr.length - 1
      # compares the two numbers, stores the biggest value in a temp var and swaps the two
      if arr[i] > arr[i+1]
        big = arr[i]
        arr[i] = arr[i+1]
        arr[i+1] = big
        swapped = true    # swapped bool set to true to avoid premature termination of process
      end
    end

    # increments the counter and resets some vars for next pass
    i += 1
    if i > arr.length - 1
      swapped = false   # this makes sure the process is terminated after a pass without any swaps
      i = 0
    end

    # checks if a swap was made during a whole pass.
    if swapped == false && i >= arr.length - 1
      break
    end

  end
  return arr  # returns the passed array, now sorted
end

arr = [1,4,9,3,2,5]
puts bubble_sort(arr).inspect
