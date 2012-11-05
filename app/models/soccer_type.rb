class SoccerType < ActiveRecord::Base
  attr_accessible :soccer_type_code, :soccer_type_name

  has_many :competitions, :class_name => 'Competition'
end
