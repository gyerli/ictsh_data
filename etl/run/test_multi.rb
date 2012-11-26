#!/usr/bin/ruby
# encoding: utf-8

require 'watir-webdriver'
require 'active_record'
require 'open-uri'
require 'nokogiri'
require 'pp'
require 'pg'
require 'yaml'
require 'date'


def parseMatches (browser, season_name, round_name, group_name) #(matches)
  line = ""
  click_away = true
  
  while click_away do
    
    matches = Nokogiri::HTML(browser.html)
    
    matches.css('div.table-container table tbody tr').each do |row|
      if row.css('td')[0].text == 'Aggr.' 
        next
      end      
      ss = row.parent.parent.parent.parent.parent.parent.css('h2').text
      if ss != season_name 
        next
      end
      date_time = DateTime.strptime(row['data-timestamp'],'%s')
      source_system_match_id = row['id'].split('-')[1]
      team_a = row.css('td')[2].text.strip
      team_b = row.css('td')[4].text.strip
      team_a_score = row.css('td')[3].text.strip.delete(' ').split('-')[0]
      team_b_score = row.css('td')[3].text.strip.delete(' ').split('-')[1]
      match_details_url = row.css('td')[3].css('a').attribute('href').text
      line =  "#{line}#{team_a}|#{team_b}|#{team_a_score}|#{team_b_score}\n"
   
    end #matches.css('div.table-container table tbody tr').each do |row|
    
    if matches.css('span.nav_description a').to_s.strip != ''
      
      if matches.css('span.nav_description a').attribute('class').to_s.strip != "previous"
        
        click_away = false
        
      else
        
        browser.a(:class => "previous").click
        sleep 1      
        
      end #matches.css('span.nav_description a').attribute('class').to_s.strip != "previous"
      
    else
      
      click_away = false
      
    end
    
  end #while
  
  puts line
  return line
  
end #parseMatches


competitionURL = 'http://localhost:3000'
outputFile = 'matches.dat'
browser = Watir::Browser.new :chrome
browser.goto competitionURL

time = Time.new
year = time.year
month = "%02d" % time.month
day = "%02d" % time.day
ts = "#{year}#{month}#{day}"

matchFile = File.new outputFile, 'w'

#write header
matchFile.write "season_name|round_name|group_name|match_id|date|team_a|team_b|team_a_score|team_b_score|match_details_url\n"

ln = parseMatches browser, "2nd Phase Reválida 2 - Finals", 'B', 'C' 
matchFile.write ln

browser.close
exit

