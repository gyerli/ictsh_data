require 'nokogiri'
require 'open-uri'

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

rec_cnt = 0
url='http://webpull.globalsportsmedia.com/soccer/get_competitions'
xml = Nokogiri::HTML(open(url, :http_basic_authentication => ['demo', 'demo']).read)
file = File.new output_file, 'w'

#write header
file.write "competition_id|name|soccertype|teamtype|display_order|type|format|area_id|area_name|countrycode\n"
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

#debugging
=begin
 line_text = "competition_id=#{competition_id}\
  name=#{name}|\
  soccertype=#{soccertype}|\
  teamtype=#{teamtype}|\
  display_order=#{display_order}|\
  type=#{type}|\
  format=#{format}|\
  area_id=#{area_id}|\
  area_name=#{area_name}|\
  countrycode=#{countrycode}"
=end

 ln = "#{competition_id}|#{name}|#{soccertype}|#{teamtype}|#{display_order}|#{type}|#{format}|#{area_id}|#{area_name}|#{countrycode}\n"
 file.write ln
 rec_cnt += 1
end

puts "#{rec_cnt} record(s) written in #{output_file}"
