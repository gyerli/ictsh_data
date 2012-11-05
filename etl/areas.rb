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

sw = SourceSystem.find_by_source_system_code('SWAY')
xml = Nokogiri::XML File.open 'data/get_areas.xml'
xml.xpath('//area').each do |area|
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

end
#xml.xpath('//resource').each { |node| puts " - #{ node['name'] } ( #{ node['version'] } )"
