def stock_picker(days)
  high, low = [0, days[0]]
  has_bought = false

  days.each_with_index do |x,i|
    if x < low
      low = x
      has_bought = true if low == days.min
    end
    if x > high && has_bought == true
      high = x
    end
  end
  if days[0] == high || days[-1] == low
    days.shift if days[0] == high
    days.pop if days[-1] == low
    buy_day, sell_day, low, high = stock_picker(days)
  end
  buy_day = days.find_index(low)
  sell_day = days.find_index(high)
  return [buy_day, sell_day, low, high]
  # return [buy, sell, low, high]
end
days = [17,3,15,4,9,15,1,8,6,2,1]
buy, sell, low, high = stock_picker(days)
puts "Buy on Day #{buy} for #{low} units\nSell on Day #{sell} for #{high} units"
