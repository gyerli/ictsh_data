# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#SourceSystem.create([{source_system_name: 'soccerway.com',source_system_code: 'SWAY',url: 'http://www.soccerway.com'}])

#CompetitionFormat.create([{competition_format_code: 'DLGE',competition_format_name: 'Domestic league'}])
#CompetitionFormat.create([{competition_format_code: 'DCUP',competition_format_name: 'Domestic cup'}])
#CompetitionFormat.create([{competition_format_code: 'ISCP',competition_format_name: 'International super cup'}])
#CompetitionFormat.create([{competition_format_code: 'ICUP',competition_format_name: 'International cup'}])
#CompetitionFormat.create([{competition_format_code: 'DSCP',competition_format_name: 'Domestic super cup'}])

CompetitionType.create([{competition_type_code: 'CLUB', competition_type_name: 'Club'}])
CompetitionType.create([{competition_type_code: 'INTRN', competition_type_name: 'International'}])

SoccerType.create([{soccer_type_code: 'CUP', soccer_type_name: 'Cup'}])
SoccerType.create([{soccer_type_code: 'TBL', soccer_type_name: 'Table'}])

TeamType.create([{team_type_code: 'DEFAULT', team_type_name: 'Default'}])
TeamType.create([{team_type_code: 'YOUTH', team_type_name: 'Youth'}])
TeamType.create([{team_type_code: 'WOMEN', team_type_name: 'Women'}])

