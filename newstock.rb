def stock_picker(days)
  # stock picker - buy low, sell high
  low = days.min
  high = days.max

  if days[0] == high || days[-1] == low
    days.shift if days[0] == high
    days.pop if days[-1] == low
    buy_day, sell_day, low, high = stock_picker(days)
  end
  buy_day = days.find_index(low)
  sell_day = days.find_index(high)
  return [buy_day, sell_day, low, high]
end
days = [17,3,15,9,15,1,8,6,2,1]
buy, sell, low, high = stock_picker(days)
puts "Buy on Day #{buy} for #{low} units.\nSell on Day #{sell} for #{high} units."
