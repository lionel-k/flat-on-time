require 'open-uri'
require 'nokogiri'
require 'json'

url = "pap.html"

urls = []
(1..10).each { |page|
  urls << "https://www.pap.fr/annonce/location-appartement-maison-residence-avec-service-paris-75-g439-jusqu-a-1000-euros-#{page}"
}

# puts urls

filepath = 'flats-pap.json'
data = []


def get_flat_details(item, flat_url)
  p full_flat_url = "https://www.pap.fr/#{flat_url}"
  # full_flat_url = "flat_pap.html"
  title = item.search('.h1').text.strip.encode('utf-8', 'iso-8859-1')
  price = item.search('.price').text.strip.encode('utf-8', 'iso-8859-1').split('Â')[0]
  price += " €"

  flat_html_file = open(full_flat_url).read
  flat_html_doc = Nokogiri::HTML(flat_html_file)
  location = flat_html_doc.search('.item-geoloc h2').text.strip
  description = flat_html_doc.search('.item-description').text.strip.encode('utf-8', 'iso-8859-1')
  # img = flat_html_doc.css('div.owl-carousel').children[1].children.first.values.first
  # puts ""

  {
    title: title,
    price: price,
    url: full_flat_url,
    location: location,
    description: description
    # img: img
  }
end

def get_flats(url)
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)
  data = []

  html_doc.search('.title-item').each do |element|
    flat_url = element.attribute('href').value
    sleep(15)
    data << get_flat_details(element, flat_url)
  end
  data
end

# 2.times do
#   data += get_flats(url)
#   p get_flats(url)
# end


urls.each do |url|
  p url
  # p "#" * 10
  data += get_flats(url)
  sleep(5)
  # p "#" * 10
end

File.open(filepath, 'wb') do |file|
  file.write(JSON.generate({ flats: data }))
end
