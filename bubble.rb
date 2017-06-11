def bubble_sort(arr)
  i = 0
  swapped = false

  loop do
    if i < arr.length - 1
      if arr[i] > arr[i+1]
        big = arr[i]
        arr[i] = arr[i+1]
        arr[i+1] = big
        swapped = true
      end
    end
    i += 1
    if i > arr.length - 1
      swapped = false
      i = 0
    end
    if swapped == false && i >= arr.length - 1
      break
    end
  end
  return arr
end

arr = [1,4,9,3,2,5]
puts bubble_sort(arr).inspect
