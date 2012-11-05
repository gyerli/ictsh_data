class CompetitionType < ActiveRecord::Base
  attr_accessible :competition_type_code, :competition_type_name


    has_many :competitions, :class_name => 'Competition'    
end
