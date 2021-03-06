#!/usr/bin/ruby

require 'watir-webdriver'
require 'active_record'
require 'open-uri'
require 'nokogiri'
require 'pp'
require 'pg'
require 'yaml'
require 'date'


def parseMatches (browser, competitionID, season_name, round_name, group_name) #(matches)
  line = ""
  match = ""
  click_away = true
  
  while click_away do
    
    matches = Nokogiri::HTML(browser.html)
    
    matches.css('div.table-container table tbody tr').each do |row|
      #puts "row=#{row.parent.parent.parent.parent.parent.parent.css('h2').text}|round=#{round_name}"
      if row.css('td')[0].text == 'Aggr.' 
        next
      end
     
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
      
      #puts "Score=#{score}"
      reg_result = case
                     when score.to_s == '-' || score.to_s.include?(':') || score.to_s.include?('PSTP') || score.to_s.include?('CANC') then next 
                     when score.split('-')[0] > score.split('-')[1] then reg_result = 'A'       
                     when score.split('-')[0] < score.split('-')[1] then reg_result = 'B'
                     when score.split('-')[0] = score.split('-')[1] then reg_result = 'D'
                   end
                         
      header = row.parent.parent.parent.parent.parent.parent.css('h2').text
      date_time = DateTime.strptime(row['data-timestamp'],'%s')
      source_system_match_id = row['id'].split('-')[1]
      team_a = row.css('td')[2].text.strip
      team_b = row.css('td')[4].text.strip
      team_a_score = score.split('-')[0]
      team_b_score = score.split('-')[1]
      match_details_url = row.css('td')[3].css('a').attribute('href').text
      match = "#{competitionID}|#{header}|#{season_name}|#{round_name}|#{group_name}|#{source_system_match_id}|#{date_time}|#{team_a}|#{team_b}|#{team_a_score}|#{team_b_score}|#{result_type}|#{reg_result}|#{final_result}|#{match_details_url}"
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
  
  #puts line
  return line
  
end #parseMatches


unless ARGV.length == 3
  puts "Dude, not the right number of arguments."
  puts "Usage: ruby sway_season_matches.rb [competitionID] [competitionURL] [outputFile] \n"
  exit
end

competitionID = ARGV[0]
competitionURL = ARGV[1]
outputFile = ARGV[2]

#competitionURL = 'http://www.soccerway.com/international/europe/european-championships'
#outputFile = 'matches.dat'
browser = Watir::Browser.new :chrome
browser.goto competitionURL

time = Time.new
year = time.year
month = "%02d" % time.month
day = "%02d" % time.day
ts = "#{year}#{month}#{day}"
season_threshold = '1999/2000'


matchFile = File.new outputFile, 'w'

#write header
matchFile.write "competition_id|header|season_name|round_name|group_name|match_id|date|team_a|team_b|team_a_score|team_b_score|result_type|reg_result|final_result|match_details_url\n"

seasons = Nokogiri::HTML(browser.html)

seasons.css("#season_id_selector option").each do |season|

  exit if season.content == season_threshold
  
  puts "season=#{season.content}"
  browser.select_list(:name => 'season_id').select season.content
  rounds = Nokogiri::HTML(browser.html)
  
  if browser.select_list(:id => "round_id_selector").exists? 
    
    puts "Rounds exists."
    
    rounds.css("#round_id_selector option").each do |round|
      
      puts "round=#{round.content}"
      browser.select_list(:name => 'round_id').select round.content
      groups = Nokogiri::HTML(browser.html)
      
      if browser.select_list(:id => "group_id_selector").exists?
         
        puts "Groups exists."
        
        groups.css("#group_id_selector option").each do |group|
          
          if group.content.to_s != ""
             
            puts "group=#{group.content}"
            browser.select_list(:name => 'group_id').select group.content
            ln = parseMatches browser, competitionID, season.content, round.content, group.content 
            matchFile.write ln
                      
          end #if group.content.to_s != ""
           
        end #groups.css("#group_id_selector option").each do |group|
        
      else #group doesn't exists
        
        ln = parseMatches browser, competitionID, season.content, round.content, nil
        matchFile.write ln
        
      end #browser.select_list(:id => "group_id_selector").exists?
      
    end #rounds.css("#round_id_selector option").each do |round|
    
  else #round doesn't exists
    
    if browser.select_list(:id => "group_id_selector").exists?
       
      # this is when Season exists with groups only withour rounds 
      puts "Groups exists."
      
      seasons.css("#group_id_selector option").each do |group|
        
        if group.content.to_s != ""
           
          puts "group=#{group.content}"
          browser.select_list(:name => 'group_id').select group.content
          ln = parseMatches browser, competitionID, season.content, nil, group.content 
          matchFile.write ln
                    
        end #if group.content.to_s != ""
        
      end 
    else #only season exists, no round no group
      
      ln = parseMatches browser, competitionID, season.content, nil, nil
      matchFile.write ln
            
    end #browser.select_list(:id => "group_id_selector").exists?
    
  end #if browser.select_list(:id => "round_id_selector").exists?
   
end #seasons.css("#season_id_selector option").each do |season|

browser.close
exit

