require 'watir-webdriver'
require 'active_record'
require 'open-uri'
require 'nokogiri'
require 'pp'
require 'pg'
require 'yaml'
require 'date'

#browser = Watir::Browser.new :chrome

ActiveRecord::Base.establish_connection(
    :adapter => "postgresql",
    :database => "lnd_sway",
    :username => "ictsh",
    :password => "gyerli"
)

class CompetitionUrl < ActiveRecord::Base
end

urls=CompetitionUrl.find(competition_id=>1064)
puts urls
 


#browser.close
exit




