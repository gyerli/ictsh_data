SELECT 
  competitions.id, 
  competitions.competition_name, 
  source_systems.source_system_name, 
  competition_types.competition_type_name, 
  areas.area_name, 
  competitions.source_system_competition_key, 
  competitions.updated_at, 
  competitions.created_at, 
  competition_formats.competition_format_name, 
  competitions.display_order_num, 
  team_types.team_type_name
FROM 
  public.competitions, 
  public.competition_types, 
  public.source_systems, 
  public.areas, 
  public.competition_formats, 
  public.team_types
WHERE 
  competition_types.id = competitions.competition_type_id AND
  source_systems.id = competitions.source_system_id AND
  areas.id = competitions.area_id AND
  competition_formats.id = competitions.competition_format_id AND
  team_types.id = competitions.team_type_id AND
  areas.area_name = 'Turkey'
  ORDER BY competitions.display_order_num;
