require 'open-uri'
require 'nokogiri'
require 'json'

urls = []
(1..2).each { |page|
  urls << "https://www.leboncoin.fr/locations/offres/ile_de_france/paris/?o=#{page}&mre=1000&ret=1&ret=2&furn=1"
}

url = "paris-select.html"

filepath = 'flats.json'
data = []

def get_flat_details(item, flat_url)
  p title = item.search('.item_title').text.strip
  price = item.search('.item_price').text.strip.split("\n")[0]

  flat_html_file = open(flat_url).read
  flat_html_doc = Nokogiri::HTML(flat_html_file)
  p img = flat_html_doc.css('div.item_image.empty').empty? ? flat_html_doc.css('.lazyload').first.attributes.values[2].value : ""
  # img = flat_html_doc.css('.lazyload').first.attributes.values[2].value
  # img ||= ""
  location = flat_html_doc.search('.line_city h2').text.strip.split("\n").last.strip
  p description = flat_html_doc.search('.properties_description').text.strip
  puts ""
  {
    title: title.encode('utf-8', 'iso-8859-1'),
    price: price,
    url: flat_url,
    location: location.encode('utf-8', 'iso-8859-1'),
    description: description.encode('utf-8', 'iso-8859-1'),
    img: img
  }
end

def get_flats(url)
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)
  data = []

  html_doc.search('.list_item').each do |element|

    flat_url = element.attribute('href').value
    p clean_flat_url = flat_url.gsub("//","https://").split("?")[0]

    sleep(2)

    data << get_flat_details(element, clean_flat_url) if clean_flat_url.include?('.htm')
  end
  data
end

data = []

# 2.times do
#   data += get_flats(url)
# end

urls.each do |url|
  p url
  p "#" * 10
  data += get_flats(url)
  sleep(5)
  p "#" * 10
end

File.open(filepath, 'wb') do |file|
  file.write(JSON.generate({ flats: data }))
end


serialized_flats = File.read(filepath)

flats = JSON.parse(serialized_flats)
p flats['flats'].size

# flats['flats'].each do |flat|
#   p flat["title"]
#   p flat["price"]
#   p flat["location"]
#   p flat["description"]
#   p flat["url"]
#   puts ""
# end
