class Competition < ActiveRecord::Base



    belongs_to :area, :class_name => 'Area', :foreign_key => :area_id    
    has_many :seasons, :class_name => 'Season'    
    belongs_to :source_system, :class_name => 'SourceSystem', :foreign_key => :source_system_id    
end
