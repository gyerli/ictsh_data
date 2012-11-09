require 'watir-webdriver'
require 'active_record'
require 'open-uri'
require 'nokogiri'
require 'pp'
require 'pg'
require 'yaml'
require 'date'

#ActiveRecord::Base.establish_connection(YAML.load_file("config/database.yml"))

ActiveRecord::Base.establish_connection(
    :adapter => "postgresql",
    :database => "two_dev",
    :username => "one",
    :password => "gyerli"
)

class RawMatch < ActiveRecord::Base
end

class SourceSystem < ActiveRecord::Base

end

sw = SourceSystem.find_by_code('SOCCERWAY')

browser = Watir::Browser.new :chrome
url = "http://localhost:3000"
#url = "http://www.soccerway.com/national/turkey/super-lig/2004-2005/round-1/matches"
dt=''
click_away = true

browser.goto url
while click_away do
  d = Nokogiri::HTML(browser.html)
  d.css('div.table-container table tbody tr').each do |row|
    #date = Date.strptime row.css('td')[1].text, '%d/%m/%y'
    #dt = row.css('td')[1].text unless row.css('td')[1].text == ''
    date_time = DateTime.strptime(row['data-timestamp'],'%s')
    source_system_match_id = row['id'].split('-')[1]
    team_a = row.css('td')[2].text.strip
    team_b = row.css('td')[4].text.strip
    team_a_score = row.css('td')[3].text.strip.delete(' ').split('-')[0]
    team_b_score = row.css('td')[3].text.strip.delete(' ').split('-')[1]
    match_details_url = row.css('td')[3].css('a').attribute('href').text
    puts "source_system_id=#{sw.id}|match_id=#{source_system_match_id}|date=#{date_time}|A=#{team_a}|B=#{team_b}|a_score=#{team_a_score}|b_score=#{team_b_score}|URL=#{match_details_url}"
    match = RawMatch.create(
        :date_time => date_time,
        :team_a => team_a,
        :team_b => team_b,
        :team_a_score => team_a_score,
        :team_b_score => team_b_score,
        :match_details_url => match_details_url,
        :source_system_match_id => source_system_match_id,
        :source_system_id => sw.id)
    match.save
  end

  browser.a(:id => "page_competition_1_block_competition_matches_6_previous").click
  sleep 1
  click_away = d.css('span.nav_description a')[0]['class'].strip == "previous"
  #pp doc.css('span.nav_description a')[0]['class']=="previous disabled"
  #pp doc.css('span.nav_description a')[0]['class']=="previous "
  #pp doc.css('span.nav_description a')[1]['class']=="next disabled"
  exit
end

puts RawMatch.count
#browser.close

