class Competition < ActiveRecord::Base
  attr_accessible :competition_name, :competition_url, :competition_format_id, :competition_type_id, :area_id, :soccer_type_id, :display_order_num, :team_type_id, :source_system_id, :source_system_competition_key


  belongs_to :area, :class_name => 'Area', :foreign_key => :area_id
  has_many :seasons, :class_name => 'Season'
  belongs_to :source_system, :class_name => 'SourceSystem', :foreign_key => :source_system_id
  belongs_to :competition_format, :class_name => 'CompetitionFormat', :foreign_key => :competition_format_id
  belongs_to :competition_type, :class_name => 'CompetitionType', :foreign_key => :competition_type_id
  belongs_to :soccer_type, :class_name => 'SoccetType', :foreign_key => :soccer_type_id
  belongs_to :team_type, :class_name => 'TeamType', :foreign_key => :team_type_id

end
