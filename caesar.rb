# a = 97, z = 122 // A = 65, Z = 90

def caesar(input, shift)
	words = input.split(" ")
	cypher_chars = []
	cypher_words = []

	words.each do |word|
		chars = word.split("")
		chars.each do |char|
			ascii = char.ord
			ascii -= shift

			# wraps around the A-Z / a-z boundaries respectively
			if char.match(/[A-Z]/)
				ascii += 26 if ascii < 65
			elsif char.match(/[a-z]/)
				ascii += 26 if ascii < 97
			end

			cypher_chars.push(ascii.chr)

		end
		cypher_words.push(cypher_chars.join(""))
		cypher_chars = []
	end

	return cypher_words.join(" ")

end

puts "ENTER YOUR QUERY TO BE CIPHERED:"
input = gets.chomp
puts caesar(input, 3)
