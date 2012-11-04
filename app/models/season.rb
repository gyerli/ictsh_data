class Season < ActiveRecord::Base



    belongs_to :competition, :class_name => 'Competition', :foreign_key => :competition_id    
    has_many :rounds, :class_name => 'Round'    
    belongs_to :source_system, :class_name => 'SourceSystem', :foreign_key => :source_system_id    
end
