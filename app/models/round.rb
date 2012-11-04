class Round < ActiveRecord::Base



    belongs_to :season, :class_name => 'Season', :foreign_key => :season_id    
    belongs_to :source_system, :class_name => 'SourceSystem', :foreign_key => :source_system_id    
    has_many :groups, :class_name => 'Group'    
    has_many :matches, :class_name => 'Match'    
end
