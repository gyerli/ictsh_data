require 'active_record'
require 'nokogiri'
require 'pp'
require 'pg'
require 'date'

ActiveRecord::Base.establish_connection(
    :adapter => "postgresql",
    :database => "ictsh_development",
    :username => "ictsh",
    :password => "gyerli"
)

class SourceSystem < ActiveRecord::Base
end

class Area < ActiveRecord::Base
end

class Competition < ActiveRecord::Base
end


sw = SourceSystem.find_by_source_system_code('SWAY')
xml = Nokogiri::XML File.open 'data/get_competitions.xml'
xml.xpath('//competition').each do |competition|
    comp_details_url = div.css('a').attribute('href').text
    comp_name = div.css('a').text
    comp_type = div.css('span.type').text
    comp_season = div.css('span.season').text
    puts "name=#{comp_name}|type=#{comp_type}|season=#{comp_season}|url=#{comp_details_url}"
    comp = Competition.create(
        :area_id => li.attribute('data-area_id').text,
        :name => comp_name,
        :competition_type => comp_type,
        :source_system_competition_id => nil,
        :source_system_id => sw.id)
    comp.save

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

end
=begin
  area_name = area['name']
  url = nil
  country_code = area['countrycode']
  source_system_area_key = area['area_id']
  puts "source_system_id=#{sw.id}|area_id=#{source_system_area_key}|area_name=#{area_name}|code=#{country_code}|URL=#{url}"
  area = Area.create(
      :country_code => country_code,
      :area_name => area_name,
      :url => url,
      :source_system_area_key => source_system_area_key,
      :source_system_id => sw.id)
  area.save
=end

#xml.xpath('//resource').each { |node| puts " - #{ node['name'] } ( #{ node['version'] } )"
