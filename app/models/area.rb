class Area < ActiveRecord::Base



    has_many :competitions, :class_name => 'Competition'    
    has_many :teams, :class_name => 'Team'    
    belongs_to :source_system, :class_name => 'SourceSystem', :foreign_key => :source_system_id    
    belongs_to :area, :class_name => 'Area', :foreign_key => :parent_id    
end
