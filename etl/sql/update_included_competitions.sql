insert into competition_etls
select competition_id from competitions
;
select * from competition_etls
;
update competition_etls
set is_included = true
where competition_id in (
select competition_id
from 
(
select competition_id, c.name, a.area_id, a.area_name
  from competitions c
	inner join areas a on ( c.area_name = a.area_name )
	inner join area_parents ap on ( a.area_name = ap.area_name )
where ap.parent_name = 'Europe' 
    and a.area_name in (
		'Denmark','Austria','Belgium','Croatia','Czech Republic',
		'England','Finland','France','Germany','Greece','Ireland Republic',
		'Italy','Netherlands','Northern Ireland','Norway','Portugal','Romania',
		'Russia','Scotland','Spain','Sweeden','Switzerland','Turkey','Ukraine','Wales')
union
select competition_id, c.name, a.area_id, a.area_name
  from competitions c
	inner join areas a on ( c.area_name = a.area_name )
	inner join area_parents ap on ( a.area_name = ap.area_name )
where ap.parent_name = 'N/C America' 
and a.area_name in ('Canada','Costa Rica','El Slvador','Honduras','Mexico','United States')
union
select competition_id, c.name, a.area_id, a.area_name
  from competitions c
	inner join areas a on ( c.area_name = a.area_name )
	inner join area_parents ap on ( a.area_name = ap.area_name )
where ap.parent_name = 'South America' 
and a.area_name in ('Argentina','Bolivia','Brazil','Chile','Colombia','Ecuador','Paraguay','Peru','Uruguay','Venezuela')
) a
)