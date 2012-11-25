require 'watir-webdriver'
require 'active_record'
require 'open-uri'
require 'nokogiri'
require 'pp'
require 'pg'
require 'yaml'
require 'date'

url = "http://localhost:3000"
browser = Watir::Browser.new :chrome
browser.goto url
html = Nokogiri::HTML(browser.html)
xml = Nokogiri::XML::Node.new(html.css('div.content-column'))
puts xml