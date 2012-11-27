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
      #pp row
      a = row.css('td.score-time a').text.strip.gsub(' ','').split("\n")
=begin
      This is resulting array of split above   
      ["4-0"]
      ["P", "0-0", "P"]
      ["1-2"]
      ["0-1"]
      ["4-2"]
      ["2-0"]
      ["P", "0-0", "P"]
=end      
      #puts row.css('td.score-time a').text.strip.gsub("\n",'').gsub(' ','')
      final_result = ''
      if a.size > 1 #when penalties or extra time (P or E)
        result_type = a[0]
        final_result = 'A' if row.css('td.score-time a span.addition-visible').attribute('class').text.include?('left')        
        final_result = 'B' if row.css('td.score-time a span.addition-visible').attribute('class').text.include?('right')
        score = a[1]
      else
        result_type = 'R' #after regulation
        score = a[0]
      end
      reg_result = case
                     when score.split('-')[0] > score.split('-')[1] then reg_result = 'A'       
                     when score.split('-')[0] < score.split('-')[1] then reg_result = 'B'
                     when score.split('-')[0] = score.split('-')[1] then reg_result = 'D'
                   end
      date_time = DateTime.strptime(row['data-timestamp'],'%s')
      source_system_match_id = row['id'].split('-')[1]
      team_a = row.css('td')[2].text.strip
      team_b = row.css('td')[4].text.strip
      team_a_score = score.split('-')[0]
      team_b_score = score.split('-')[1]
      match_details_url = row.css('td')[3].css('a').attribute('href').text
      match = "#{season_name}|#{round_name}|#{group_name}|#{source_system_match_id}|#{date_time}|#{team_a}|#{team_b}|#{team_a_score}|#{team_b_score}|#{result_type}|#{reg_result}|#{final_result}|#{match_details_url}"
      line = "#{line}#{match}\n"
      puts match         
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
  
#  puts line
#  return line
  
end #parseMatches


competitionURL = 'http://localhost:3000'
outputFile = 'matches.dat'
browser = Watir::Browser.new :chrome
browser.goto competitionURL

parseMatches browser, nil, nil, nil 

browser.close
exit

