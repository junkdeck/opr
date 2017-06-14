require 'net/http'
puts "Enter address to scrape for links:"
url_input = gets.chomp

unless url_input.include?('http://')
	url_input = "http://#{url_input}/"
end
puts url_input

url = URI.parse(url_input)
response = Net::HTTP.start(url.host, url.port) do |http|
	http.get(url.path)
end
link_lines = []
links = []
full_links = []
content = response.body
content.each_line do |line|
	if line.include?("<a")
		link_lines << line.strip
	end
end
	link_lines.each do |line|
		rx = /href=('|").+?('|")/ 
		new = rx.match(line).to_s
		url_only = /('|").+?('|")/.match(new)
		links << url_only.to_s[1..-2]
	end

	links.each do |x|
		if x.class != NilClass
			if x[0] == '.' 
				full_links << "http://#{url.host}/#{x[2..-1]}"
			elsif x[0] == '/'
				full_links << "http://#{url.host}/#{x[1..-1]}"
			else
				full_links << x
			end
		end
	end

	puts full_links.uniq.sort
