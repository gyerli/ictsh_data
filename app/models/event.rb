class Event < ActiveRecord::Base



    belongs_to :source_system, :class_name => 'SourceSystem', :foreign_key => :source_system_id    
    belongs_to :person, :class_name => 'Person', :foreign_key => :person_id    
    belongs_to :team, :class_name => 'Team', :foreign_key => :team_id    
end
