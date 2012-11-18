require 'nokogiri'

#(Attr:0xfad868 { name = "competition_id", value = "1013" }),
#(Attr:0xfad818 { name = "name", value = "A-Division" }),
#(Attr:0xfad804 { name = "soccertype", value = "default" }),
#(Attr:0xfad7a0 { name = "teamtype", value = "default" }),
#(Attr:0xfad78c { name = "display_order", value = "10" }),
#(Attr:0xfad728 { name = "type", value = "club" }),
#(Attr:0xfad714 { name = "format", value = "Domestic league" }),
#(Attr:0xfad6b0 { name = "area_id", value = "233" }),
#(Attr:0xfad430 { name = "area_name", value = "Tuvalu" }),
#(Attr:0xfad41c { name = "countrycode", value = "TVL" })]

#xml = Nokogiri::XML File.open '/home/gursoy/work/ictsh/etl/data/source/sway/get_areas.xml'
#file = File.new '/home/gursoy/work/ictsh/etl/data/intake/areas.dat', 'w'
#ln = "area_id|area_name|country_code\n"
#xml.xpath('//area').each do |area|
#  area_id = area['area_id']
#  area_name = area['name']
#  country_code = area['countrycode']
#  ln = "#{area_id}|#{area_name}|#{country_code}\n"
#  file.write ln
#end

xml = Nokogiri::XML File.open '/home/gursoy/work/ictsh/etl/data/source/sway/get_competitions.xml'
file = File.new '/home/gursoy/work/ictsh/etl/data/intake/areas.dat', 'w'

xml.xpath('//competition').each do |c|
 competition_id=c['competition_id']
 name=c['name']
 soccertype=c['soccertype']
 teamtype=c['teamtype']
 display_order=c['display_order']
 type=c['type']
 format=c['format']
 area_id=c['area_id']
 area_name=c['area_name']
 countrycode=c['countrycode']
 line_text = "competition_name=#{competition_name}|\
competition_format_id=#{competition_format_id}|\
competition_type_id=#{competition_type_id}| \
area_id=#{area_id}|\
soccer_type_id=#{soccer_type_id}|\
display_order_num=#{display_order_num}|\
team_type_id=#{team_type_id}|\
source_system_id=#{sw.id}|\
source_system_competition_key=#{source_system_competition_key}"
  puts line_text.inspect
end
