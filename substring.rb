def substrings(match, dictionary)
  # takes one or several words and matches them to a dictionary. outputs a case insensitive hash with each substring and the amount of occurences
  word_hash = Hash.new(0)
  match.split.each do |word|
    dictionary.each do |dic|
      word_hash[dic.downcase] += 1 if word.downcase.include?(dic.downcase)
    end
  end
  return word_hash
end

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
puts "Single word substrings: #{substrings("below", dictionary)}"
puts "Multiple words substrings: #{substrings("Howdy partner, sit down! How's it going?", dictionary)}"
