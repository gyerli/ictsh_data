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
url = "http://www.soccerway.com/international/world/world-cup"
#url = "https://spreadsheets.google.com/viewform?hl=en&formkey=dDliTk5XU1R4RUMtb2c1WDZxWHNENmc6MQ#gid=0"
##url = "http://www.soccerway.com/national/turkey/super-lig/2004-2005/round-1/matches"
#url = "http://www.soccerway.com/competitions"
#click_away = true


width = browser.execute_script("return screen.width;")
height = browser.execute_script("return screen.height;")
browser.driver.manage.window.move_to(0,0)
browser.driver.manage.window.resize_to(width,height)
browser.goto url

#pp browser.select_list(:name => 'season_id').options
#browser.select_list(:name => 'season_id').select '2008/2009'


seasons = Nokogiri::HTML(browser.html)
seasons.css("#season_id_selector option").each do |sea|
  puts "season=#{sea.content}"
  browser.select_list(:name => 'season_id').select sea.content
  rnd = Nokogiri::HTML(browser.html)
  rnd.css("#round_id_selector option").each do |ro|
    puts "round=#{ro.content}"
    browser.select_list(:name => 'round_id').select ro.content
    grp = Nokogiri::HTML(browser.html)
    grp.css("#group_id_selector option").each do |gr|
      puts "group=#{gr.content}"
      browser.select_list(:name => 'group_id').select gr.content
      matches = Nokogiri::HTML(browser.html)
    end
  end
end

browser.close
exit




