drop table netflix if exists
alter table netflix
alter column date_added type varchar(25);
create table netflix
(
	show_id varchar(8),
	type varchar (10),
	title varchar(150),
	director varchar(250),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(25),
	release_year int,
	rating varchar(10),
	duration varchar(15),
	listed_in varchar(100),
	description varchar (300)

);

select * from netflix

select count(*) as total_content 
from netflix

select distinct (type)
from netflix

-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows
select type,count(*) as content_count
	from netflix
	group by type


--2. Find the most common rating for movies and TV shows

	
with cte as(
 select type,rating,count(*) as total_count,
	rank() over (partition by type order by count(*) desc) as rank
    from netflix
	group by 1,2

)	
	select type ,rating from cte
	where rank <=1
	
--3. List all movies released in a specific year (e.g., 2020)

	select *
	from netflix
	where type = 'Movie' and release_year = 2020 

	
--4. Find the top 5 countries with the most content on Netflix



select unnest(string_to_array(country,',')) as country ,
	count(*) as total_content
	from netflix
    group by 1
	order by 2 desc
	limit 5

	
--5. Identify the longest movie?

	select * from netflix
	where type like 'Movie' and 
    duration = (select max(duration) from netflix)

	
	
--6. Find content added in the last 5 years

select *, to_date(date_added,'month,DD,YYYY')
from netflix
	where to_date(date_added,'month,DD,YYYY') >= current_date - interval '5 years';

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!


select *
	from netflix
	where director like '%Rajiv Chilaka%'

	
--8. List all TV shows with more than 5 seasons

select *
from netflix
where type ilike 'tv show' 
and split_part(duration,' ',1)::numeric > 5
	
--9. Count the number of content items in each genre
  
	select unnest(string_to_array(listed_in,',')) as genre ,count(*) as no_of_content
	from netflix
	group by genre
	

--10.Find each year and the average numbers of content release in India on netflix. 
 return top 5 year with highest avg content release!

	select extract (year from to_date(date_added,'month DD,YYYY')) as date,country,
	count(*) as content,
	round(count(*)::numeric / (select count(*) from netflix where country='India')::numeric * 100,2) as avg_content_per_year
	from netflix
	where country like 'India'
	group by 1,2
	order by 3 desc





	
--11. List all movies that are documentaries
     select *
	from netflix
	where type = 'Movie' and listed_in ilike'%Documentaries%' 

	
--12. Find all content without a director

	
	select * from netflix
	where director is null



--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
    select *
	from netflix
	where type like 'Movie'
	and
	casts ilike '%Salman Khan%' and
	release_year >= extract(year from current_date - interval '10 years')

	
--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

	select unnest(string_to_array(casts,',')) as actors , count(*) as count_of_appearence
	from netflix
	where country ilike '%India%' and type like 'Movie'
	group by 1
	order by 2 desc
	limit 10


	
--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

with cte as (
     select  *,
        case
          when description ilike '%Kill%' or 
	       description ilike '%violence%' then 'Bad' 
         else 'Good'
         end as Remark
         from netflix
	)
select remark,
count(*) as total_count
from cte 
group by 1 



