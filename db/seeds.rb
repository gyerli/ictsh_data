# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
source_system = SourceSystem([{source_system_name: 'soccerway.com'},{source_system_code: 'SWAY'},{url: 'http://www.soccerway.com'}])
