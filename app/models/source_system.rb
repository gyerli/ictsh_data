class SourceSystem < ActiveRecord::Base
  attr_accessible :source_system_code, :source_system_name


    has_many :areas, :class_name => 'Area'    
    has_many :competitions, :class_name => 'Competition'    
    has_many :events, :class_name => 'Event'    
    has_many :groups, :class_name => 'Group'    
    has_many :matches, :class_name => 'Match'    
    has_many :persons, :class_name => 'Person'    
    has_many :rounds, :class_name => 'Round'    
    has_many :seasons, :class_name => 'Season'    
    has_many :teams, :class_name => 'Team'    
end
