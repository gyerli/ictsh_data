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
#url = "http://www.soccerway.com/national/turkey/super-lig/2004-2005/round-1/matches"
url = "http://www.soccerway.com/competitions"
click_away = false

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

browser.goto url
doc = Nokogiri::HTML(browser.html)
#doc.css('ul.index-tree li.row').each do |li|
doc.css('ul.areas li.expandable').each do |li|
  #pp li
  source_system_area_key = li.attribute('data-area_id')
  puts "source_system_id=#{sw.id}|area_id=#{source_system_area_key}"
   
  if source_system_area_key.to_s.strip == "185"
    click_away = true
  end
  
  browser.li(:xpath, "//li[@data-area_id='#{source_system_area_key}']").click if click_away
 
  #puts area_name = li.css('a').text.strip
  #url = li.css('div a').attribute('href').text.strip
  #area_code = url.split('/')[2].to_s
  #source_system_area_key = li.attribute('data-area_id').text
  #puts "source_system_id=#{sw.id}|area_id=#{source_system_area_key}|area_name=#{area_name}|code=#{area_code}|URL=#{url}"
  #browser.li(:xpath, "//li[@data-area_id='#{source_system_area_key}']").click
  browser.send_keys :space
    
  if click_away 
    sleep 1
    break
  end
end

doc_comp = Nokogiri::HTML(browser.html)
#doc_comp.css('div.area-competitions').each do |div|
doc_comp.css('div.row').each do |div|  
  div.css('table tbody tr').each do |tr|
    #pp tr
    c_url=tr.css('td a').attribute('href').text
    c_name = tr.css('td a').text.strip
    puts "name=#{c_name}|url=#{c_url}"
    comp = Competition.find_by_competition_name(c_name)
    if comp
      puts 'Found'
      comp.competition_url = c_url 
      comp.save 
    else
      puts 'Empty'
    end
    #comp_details_url = div.css('a').attribute('href').text
    #comp_name = div.css('a').text
    #comp_type = div.css('span.type').text
    #comp_season = div.css('span.season').text
    #puts "name=#{comp_name}|type=#{comp_type}|season=#{comp_season}|url=#{comp_details_url}"
    #comp = Competition.create(
    #    :area_id => li.attribute('data-area_id').text,
    #    :name => comp_name,
    #    :competition_type => comp_type,
    #    :source_system_competition_id => nil,
    #    :source_system_id => sw.id)
    #comp.save
  end
  #exit if li.css('a').text.strip == 'Angola'
end


browser.close
exit




