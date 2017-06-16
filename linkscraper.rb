# some refactoring required. right now minified html does not scrape properly, as it's all on one line, so only the very first link gets selected.
# i could just skip the whole "by-the-lines" process and directly RegExp#scan for any matches on /<a href=('|").+?('|")/
# and store the matches in an array, then iterate through the array instead of using THREE(3) arrays!!!
# might also rewrite the code to use classes and functions instead of one long procedural process that restarts by going back to the top - maybe do recursion instead?

require 'net/http'

while true

	lines_including_links = []
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
	rescue
		puts "Couldn't establish a connection, try again!"
		# goes to the next iteration of the while loop, ignoring rest of code
	 	next
	end
	# end of error handling

	content = response.body
	# returns the subgroup containing the actual path on every match on the regular expression.
	# looks for anchor tags and accepts both quotes and apostrophes. ignores empty hashtag links.
	links << content.scan(/<a href=['|"]([^#].+?)['|"]/)
	puts links

	# content.each_line do |line|
	# 	if /<a href=('|").+?('|")/.match(line)
	# 		lines_including_links << line.strip
	# 	end
	# end
		# lines_including_links.each do |line|
		# 	rx = /href=('|").+?('|")/
		# 	new = rx.match(line).to_s
		# 	url_only = /('|").+?('|")/.match(new)
		# 	links << url_only.to_s[1..-2]
		# end
		#
		# links.each do |x|
		# 	if x.class != NilClass
		# 		if x[0] == '.'
		# 			links_absolute << "http://#{url.host}/#{x[2..-1]}"
		# 		elsif x[0] == '/'
		# 			links_absolute << "http://#{url.host}/#{x[1..-1]}"
		# 		else
		# 			links_absolute << x
		# 		end
		# 	end
		# end
		# links_absolute[0] = "No links found!" if links.empty?
		# puts links_absolute.uniq.sort
		# puts links.empty? ? "No links found!" : links_absolute.uniq.sort
		# links_absolute = []
	end
