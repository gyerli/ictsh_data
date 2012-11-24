require 'watir-webdriver'
require 'active_record'
require 'open-uri'
require 'nokogiri'
require 'pp'
require 'pg'
require 'yaml'
require 'date'

browser = Watir::Browser.new :chrome
#url = "http://localhost:3000"
url = "http://www.soccerway.com/international/europe/uefa-champions-league"
##url = "http://www.soccerway.com/national/turkey/super-lig/2004-2005/round-1/matches"
#url = "http://www.soccerway.com/competitions"
#click_away = true

ActiveRecord::Base.establish_connection(
    :adapter => "postgresql",
    :database => "lnd_sway",
    :username => "ictsh",
    :password => "gyerli"
)


class CompetitionUrls < ActiveRecord::Base
end

urls = CompetitionUrls.find(:all)

urls.each do |c_url|
  puts c_url.url  
end


browser.goto url
doc = Nokogiri::HTML(browser.html)
doc.css('div.submenu_dropdown select.dropdown-selector option').each do |option|
  attribute_type = option.parent.attribute('name')
  attribute_value = option.content
  puts "parent=#{attribute_type}|#{attribute_value}" unless attribute_value == ''
  #puts select.attribute('value').text
end

browser.close
exit




