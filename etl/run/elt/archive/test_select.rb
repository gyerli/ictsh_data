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
url = "http://www.soccerway.com/international/europe/european-championships"
#url = "https://spreadsheets.google.com/viewform?hl=en&formkey=dDliTk5XU1R4RUMtb2c1WDZxWHNENmc6MQ#gid=0"
##url = "http://www.soccerway.com/national/turkey/super-lig/2004-2005/round-1/matches"
#url = "http://www.soccerway.com/competitions"
click_away = true


width = browser.execute_script("return screen.width;")
height = browser.execute_script("return screen.height;")
browser.driver.manage.window.move_to(0,0)
browser.driver.manage.window.resize_to(width,height)
browser.goto url

#pp browser.select_list(:name => 'season_id').options
#browser.select_list(:name => 'season_id').select '2008/2009'


doc = Nokogiri::HTML(browser.html)
doc.css("#season_id_selector option").each do |sea|
  puts "season=#{sea.content}"
  browser.select_list(:name => 'season_id').select sea.content
  doc.css("#round_id_selector option").each do |ro|
    puts "round=#{ro.content}"
    browser.select_list(:name => 'round_id').select ro.content
    if browser.select_list(:id => "group_id_selector").exists? then
      puts "Looping through groups."
      doc.css("#group_id_selector option").each do |gr|
        if gr.content.to_s != "" then
          puts "group=#{gr.content}"
          browser.select_list(:name => 'group_id').select gr.content
        end
      end
    else
      puts "Group doesn't exists in this round."
    end
    while click_away do
      matches = Nokogiri::HTML(browser.html)
      matches.css('div.table-container table tbody tr').each do |row|
        #date = Date.strptime row.css('td')[1].text, '%d/%m/%y'
        #dt = row.css('td')[1].text unless row.css('td')[1].text == ''
        date_time = DateTime.strptime(row['data-timestamp'],'%s')
        source_system_match_id = row['id'].split('-')[1]
        team_a = row.css('td')[2].text.strip
        team_b = row.css('td')[4].text.strip
        team_a_score = row.css('td')[3].text.strip.delete(' ').split('-')[0]
        team_b_score = row.css('td')[3].text.strip.delete(' ').split('-')[1]
        match_details_url = row.css('td')[3].css('a').attribute('href').text
        puts "match_id=#{source_system_match_id}|date=#{date_time}|A=#{team_a}|B=#{team_b}|a_score=#{team_a_score}|b_score=#{team_b_score}|URL=#{match_details_url}"
      end #matches.css
    
      browser.a(:id => "page_competition_1_block_competition_matches_6_previous").click
      sleep 1
      click_away = d.css('span.nav_description a')[0]['class'].strip == "previous"
      #pp doc.css('span.nav_description a')[0]['class']=="previous disabled"
      #pp doc.css('span.nav_description a')[0]['class']=="previous "
      #pp doc.css('span.nav_description a')[1]['class']=="next disabled"
      end #while click_away
    end
  end
end

browser.close
exit




