copy (
select 
  a.competition_id,
  a.loc || '/' || a.a_name || '/' || a.competition_name url
from (select 
	c.competition_id,
	a.area_name,
	c.name,
	case 
	  when a.country_code is null then 'international'
	  else 'national'
	end loc,
	replace(lower(a.area_name),' ','-') a_name,
	replace(replace(replace(replace(lower(c.name),' ','-'),'/',''),'(',''),')','') competition_name
       from competitions c
    inner join areas a on (c.area_id = a.area_id)
   ) a 
) to '/var/lib/postgresql/9.1/myfile1.csv'
delimiter '|'