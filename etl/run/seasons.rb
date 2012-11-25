require 'watir-webdriver'
require 'active_record'
require 'open-uri'
require 'nokogiri'
require 'pp'
require 'pg'
require 'yaml'
require 'date'

def parseMatches (matches)
  matches.css('div.content-column div div div div.table-container table tbody tr').each do |row|
    date_time = DateTime.strptime(row['data-timestamp'],'%s')
    source_system_match_id = row['id'].split('-')[1]
    team_a = row.css('td')[2].text.strip
    team_b = row.css('td')[4].text.strip
    team_a_score = row.css('td')[3].text.strip.delete(' ').split('-')[0]
    team_b_score = row.css('td')[3].text.strip.delete(' ').split('-')[1]
    match_details_url = row.css('td')[3].css('a').attribute('href').text
    return "match_id=#{source_system_match_id}|date=#{date_time}|A=#{team_a}|B=#{team_b}|a_score=#{team_a_score}|b_score=#{team_b_score}|URL=#{match_details_url}"
  end #matches.css('div.table-container table tbody tr').each do |row|
end


browser = Watir::Browser.new :chrome
url = "http://www.soccerway.com/international/europe/european-championships"
click_away = true
matches = nil


width = browser.execute_script("return screen.width;")
height = browser.execute_script("return screen.height;")
browser.driver.manage.window.move_to(0,0)
browser.driver.manage.window.resize_to(width,height)
browser.goto url

seasons = Nokogiri::HTML(browser.html)
seasons.css("#season_id_selector option").each do |season|
  puts "season=#{season.content}"
  browser.select_list(:name => 'season_id').select season.content
  rounds = Nokogiri::HTML(browser.html)
  rounds.css("#round_id_selector option").each do |round|
    puts "round=#{round.content}"
    browser.select_list(:name => 'round_id').select round.content
    groups = Nokogiri::HTML(browser.html)
    if browser.select_list(:id => "group_id_selector").exists? then
      puts "Groups exists."
      groups.css("#group_id_selector option").each do |group|
        if group.content.to_s != "" then
          puts "group=#{group.content}"
          browser.select_list(:name => 'group_id').select group.content
          puts parseMatches Nokogiri::HTML(browser.html)
          
        end #if group.content.to_s != "" then
      end #groups.css("#group_id_selector option").each do |group|
    else
      puts parseMatches groups
    end #browser.select_list(:id => "group_id_selector").exists?
  end #rounds.css("#round_id_selector option").each do |round|
end #seasons.css("#season_id_selector option").each do |season|

browser.close
exit
