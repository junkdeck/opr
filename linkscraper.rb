require 'net/http'

while true
	links = []
	links_absolute = []

	puts "Enter address to scrape for links:"
	url_input = gets.chomp

	break if url_input == 'exit'

	unless url_input.include?('http://')
		url_input = "http://#{url_input}/"
	end

	# error handling
	begin
		url = URI.parse(url_input)
		response = Net::HTTP.start(url.host, url.port) do |http|
			http.get(url.path)
		end
	rescue => e
		puts "EXCEPTION CAUGHT: #{e.class}"
		puts "Couldn't establish a connection, try again!\n\n"
		# goes to the next iteration of the while loop, ignoring rest of code
		next
	end
	# end of error handling

	content = response.body
	# returns the subgroup containing the actual path on every match on the regular expression. 2d array.
	# looks for anchor tags and accepts both quotes and apostrophes. ignores empty and reference hashtag links
	link_pattern = /<a href=['"]([^#]*?)['"]/
	links = content.scan(link_pattern)

0
	if links.empty?
		puts "No links found!"
	else
		links.each do |x,dummy|
			# dummy block variable just makes Array#each pass the first item of the array instead of the array as a whole.
			# since the links array is 2d and each sub-array only contains one string, it essentially stringifies the sub-arrays. very handy.

			unless x.empty?
				#format the link properly depending on the anchor link context
				if x.include?("http") || x.include?("www") || x.include?("mailto:")
					if x[0..1] == "//"
						puts "#{url.scheme}//#{x[2..-1]}"
					else
						puts x
					end
				elsif x[0] == '.'
					puts "#{url.scheme}://#{url.host}/#{x[2..-1]}"
				elsif x[0] == '/'
					puts "#{url.scheme}://#{url.host}/#{x[1..-1]}"
				else
					puts "#{url.scheme}://#{url.host}/#{x}"
				end
			end
		end
	end
end
