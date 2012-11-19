require 'nokogiri'

unless ARGV.length == 2
  puts "Dude, not the right number of arguments."
  puts "Usage: ruby sway_areas.rb [source system] [inputfile] [outputfile] \n"
  exit
end

rec_cnt = 0
input_file = ARGV[0]
output_file = ARGV[1]

#xml = Nokogiri::XML File.open '/home/gursoy/work/ictsh/etl/data/source/sway/get_areas.xml'
xml = Nokogiri::XML File.open input_file
#file = File.new '/home/gursoy/work/ictsh/etl/data/intake/sway/areas.dat', 'w'
file = File.new output_file, 'w'
file.write "area_id|area_name|country_code\n"
xml.xpath('//area').each do |area|
  area_id = area['area_id']
  area_name = area['name']
  country_code = area['countrycode']
  ln = "#{area_id}|#{area_name}|#{country_code}\n"
  file.write ln
  rec_cnt += 1
end
puts "#{rec_cnt} record(s) written in #{output_file}"
