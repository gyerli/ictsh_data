class Match < ActiveRecord::Base



    belongs_to :source_system, :class_name => 'SourceSystem', :foreign_key => :source_system_id    
    belongs_to :team, :class_name => 'Team', :foreign_key => :team_a_id    
    belongs_to :team, :class_name => 'Team', :foreign_key => :team_b_id    
    belongs_to :group, :class_name => 'Group', :foreign_key => :group_id    
    belongs_to :round, :class_name => 'Round', :foreign_key => :round_id    
end
