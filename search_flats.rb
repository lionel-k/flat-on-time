require 'json'

filepath = 'flats.json'
serialized_flats = File.read(filepath)

unserialized_flats = JSON.parse(serialized_flats)

flats = Hash.new { |hash, key| hash[key] = [] }
months = [ "january", "february", "march", "april", "others" ]

unserialized_flats['flats'].each do |flat|
  description = flat["description"]

  if description.match(/\b[j|J]anvier\b/)
    flats["january"] << flat
  elsif description.match(/\b[f|F]Ã©vrier\b/)
    flats["february"] << flat
  elsif description.match(/\b[m|M]ars\b/)
    flats["march"] << flat
  elsif description.match(/\b[a|A]vril\b/)
    flats["april"] << flat
  else
    flats["others"] << flat
  end

end

months.each do |month|
  p "#{month} - #{flats[month].size}"
end

# flats["february"].each do |flat|
#   puts flat['url']
# end

# janvier 13
# fÃ©vrier 7
# mars
