class Group < ActiveRecord::Base



    belongs_to :source_system, :class_name => 'SourceSystem', :foreign_key => :source_system_id    
    belongs_to :round, :class_name => 'Round', :foreign_key => :round_id    
    has_many :matches, :class_name => 'Match'    
end
