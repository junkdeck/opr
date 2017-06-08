def histogram(input)

	words = input.split(" ")
	history = Hash.new(0)

	words.each do |x|
		history[x] += 1
	end

	history = history.sort_by do |a,b|
		b
	end
	history.reverse!

	history.each do |x,y|
		puts "#{x}: #{y}"
	end

end

input = gets.chomp
histogram(input)
