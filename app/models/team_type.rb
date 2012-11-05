class TeamType < ActiveRecord::Base
  attr_accessible :team_type_code, :team_type_name

  has_many :competitions, :class_name => 'Competition'
end
