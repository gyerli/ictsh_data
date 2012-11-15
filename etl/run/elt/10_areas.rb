require 'nokogiri'

xml = Nokogiri::XML File.open '/home/gursoy/work/ictsh/etl/data/source/sway/get_areas.xml'
file = File.new '/home/gursoy/work/ictsh/etl/data/intake/areas.dat', 'w'
ln = "area_id|area_name|country_code\n"
xml.xpath('//area').each do |area|
  area_id = area['area_id']
  area_name = area['name']
  country_code = area['countrycode']
  ln = "#{area_id}|#{area_name}|#{country_code}\n"
  file.write ln
end
