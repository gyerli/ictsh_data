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

class CompetitionFormat < ActiveRecord::Base

end

class SoccerType < ActiveRecord::Base

end

class TeamType < ActiveRecord::Base

end

class CompetitionType < ActiveRecord::Base

end

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

sw = SourceSystem.find_by_source_system_code('SWAY')
xml = Nokogiri::XML File.open 'data/get_competitions.xml'
xml.xpath('//competition').each do |c|
  #pp c
  #puts c['type']
  #puts "soccer_type=#{c['soccertype']}|format=#{c['format']}|teamtype=#{c['teamtype']}|type=#{c['type']}"
  competition_name=c['name']
  competition_format_id=CompetitionFormat.first(:conditions => ["lower(competition_format_name) = ?", c['format'].downcase]).id
  competition_type_id=CompetitionType.first(:conditions => ["lower(competition_type_name) = ?", c['type'].downcase]).id
  soccer_type_id=nil#SoccerType.first(:conditions => ["lower(soccer_type_name) = ?", c['soccertype'].downcase]).id
  area_id=Area.find_by_source_system_area_key(c['area_id']).id
  display_order_num=c['display_order']
  team_type_id=TeamType.first(:conditions => ["lower(team_type_name) = ?", c['teamtype'].downcase]).id
  source_system_competition_key=c['competition_id']
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

  competition = Competition.create(
    :competition_name => competition_name,
    :competition_format_id => competition_format_id,
    :competition_type_id =>competition_type_id,
    :area_id =>area_id,
    :soccer_type_id =>soccer_type_id,
    :display_order_num =>display_order_num,
    :team_type_id =>team_type_id,
    :source_system_id =>sw.id,
    :source_system_competition_key =>source_system_competition_key
  )
  competition.save

end