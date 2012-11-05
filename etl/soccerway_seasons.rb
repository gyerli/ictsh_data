#require 'watir-webdriver'
require 'active_record'
require 'open-uri'
#require 'nokogiri'
require 'pp'
require 'pg'
require 'yaml'
require 'date'

#browser = Watir::Browser.new :chrome
#click_away = true

ActiveRecord::Base.establish_connection(
    :adapter => "postgresql",
    :database => "two_dev",
    :username => "one",
    :password => "gyerli"
)

class Area < ActiveRecord::Base
end

class Competition < ActiveRecord::Base
end

#sw = SourceSystem.find_by_code('SOCCERWAY')

#area = Area.find_by_code("turkey")
#competitions = Competition.find_by_area_id(area.id)

#competitions do |competition|
#  puts competition.name
#end

#a = Area.where(:code=>"turkey")
pp Area
pp Competition

#Competition.all.each do |c|
#  puts c.name if c.area_id == a(:id)
#end

#@comp.each do |c|
#  pp c
#end





