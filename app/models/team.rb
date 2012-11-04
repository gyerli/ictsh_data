class Team < ActiveRecord::Base



    belongs_to :area, :class_name => 'Area', :foreign_key => :area_id    
    belongs_to :source_system, :class_name => 'SourceSystem', :foreign_key => :source_system_id    
    has_many :matches, :class_name => 'Match'    
    has_many :matches, :class_name => 'Match'    
    has_many :events, :class_name => 'Event'    
end
