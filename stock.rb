def stock_picker(days)
  high, low = [0, days[0]]
  buy, sell = [0,0]
  has_bought = false
  days.each_with_index do |x,i|
    if x < low
      low = x
      buy = i
      has_bought = true if low == days.min
    end
    if x > high && has_bought == true
      high = x
      sell = i
    end
  end
  return [buy, sell]
end
days = [17,3,6,9,15,8,6,2,1]
buy, sell = stock_picker(days)
puts "Buy on Day #{buy}\nSell on Day #{sell}"
