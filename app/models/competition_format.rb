class CompetitionFormat < ActiveRecord::Base
    attr_accessible :competition_format_code, :competition_format_name

    has_many :competitions, :class_name => 'Competition'    
end
