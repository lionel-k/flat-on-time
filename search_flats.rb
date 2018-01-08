require 'json'

filepath = 'flats-leboncoin.json'
serialized_flats = File.read(filepath)

unserialized_flats = JSON.parse(serialized_flats)

flats = Hash.new { |hash, key| hash[key] = [] }
months = [ "january", "february", "march", "april", "may", "others" ]

unserialized_flats['flats'].each do |flat|
  description = flat["description"]

  if description.match(/\b[j|J]anvier\b|\b01\b/)
    flats["january"] << flat
  elsif description.match(/\b[f|F]Ã©vrier\b|\b02\b/)
    flats["february"] << flat
  elsif description.match(/\b[m|M]ars\b|\b03\b/)
    flats["march"] << flat
  elsif description.match(/\b[a|A]vril\b|\b04\b/)
    flats["april"] << flat
  elsif description.match(/\b[m|M]ai\b|\b05\b/)
    flats["may"] << flat
  else
    flats["others"] << flat
  end

end

months.each do |month|
  p "#{month} - #{flats[month].size}"
end

flats["may"].each do |flat|
  puts flat['url']
end

output = "result-search.json"

File.open(output, 'wb') do |file|
  file.write(JSON.generate(flats))
end
