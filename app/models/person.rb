class Person < ActiveRecord::Base



    belongs_to :source_system, :class_name => 'SourceSystem', :foreign_key => :source_system_id    
    has_many :events, :class_name => 'Event'    
end
