create database ipl_2008_to_2020 ;  
use ipl_2008_to_2020;
show tables;
select * from ipl_ball_by_ball_2008_2020;
select * from ipl_matches_2008_to_2020;

-- PROBLEMS 

-- QUES-1 What was the number of matches played in each season.(per season)?

select year(date) as Season_year ,count(id) as Match_played from ipl_matches_2008_to_2020
group by year(date)
order by season_year asc;

-- Ques-2 Write sql query to find the player what won player of match award maximum time(Most player of match award playername) In All seasons?

with cte1 as
(select player_of_match as player_name ,count(player_of_match) as Number_plyer_of_match , dense_rank() over(order by count(player_of_match) desc) as rn  
from  ipl_matches_2008_to_2020
group by player_of_match)
select * from cte1 
where rn=1;

-- Ques-3 Write sql query to find the player what won player of match award maximum time(Most player of match award playername) Per seasons?

with cte1 as
(select year(date) as Season_Year,player_of_match as player_name ,count(player_of_match) as Number_plyer_of_match , dense_rank() over(order by count(player_of_match) desc) as rn  
from  ipl_matches_2008_to_2020
group by player_of_match , Year(date))
select * from cte1 
where rn=1;

-- Ques-4 Write sql query to find which team won most matches in all seasons (most win by any team) ?

select winner , count(winner) as Number_of_wins from ipl_matches_2008_to_2020
group by winner
order by Number_of_wins desc
limit 1 offset 0;

-- Ques-5 Write sql query to find the top 5 venue where most match played ?

select  venue , count(1) as Match_played from ipl_matches_2008_to_2020
group by venue
order by match_played desc
limit 5 offset 0;

-- Ques-6 write sql query to find most run by any player in all seasons ?

select batsman , sum(batsman_runs) as total_runs from ipl_ball_by_ball_2008_2020
group by batsman
order by total_runs desc
limit 1 offset 0;

-- Ques-7 Write sql query to find the total runs , six , four in all seasons ?

select count(case when batsman_runs =6 then 1 else null end) as Total_sixs, 
       count(case when batsman_runs =4 then 1 else null end ) as Total_fours,
	   sum(total_runs) as Total_runs from ipl_ball_by_ball_2008_2020;
       
       
-- Ques-8 Write sql query to find the total runs , six , four per seasons ?

select year(date) as season_year,count(case when batsman_runs =6 then 1 else null end) as Total_sixs, 
       count(case when batsman_runs =4 then 1 else null end ) as Total_fours,
	   sum(total_runs) as Total_runs 
       from ipl_ball_by_ball_2008_2020 as i
       join ipl_matches_2008_to_2020 as b on b.id=i.id 
       group by year(date)
       order by season_year;  
       
-- Ques-9 Write an query to find the percentage of run score by player in the total_runs in ipl (means how many % contribute of player from total runs in ipl)?
 
 with cte1 as
(select  batsman , sum(batsman_runs) over(partition by batsman) as total_runs ,
sum(total_runs) over() as ipl_Total_runs from ipl_ball_by_ball_2008_2020)

select batsman , total_runs , ipl_total_runs , round(total_runs/ipl_total_runs,3) from cte1
group by batsman 
order by total_runs desc;

-- Ques-10 Write sql query to find the most sixs  by any batsman ?

select batsman,count(1) as Total_sixs
	    from ipl_ball_by_ball_2008_2020
        where batsman_runs =6
        group by batsman
        order by total_sixs desc
        limit 1 offset 0;
        
        
-- Ques-11 Write sql query to find the most Fours by any batsman ?

select batsman,count(1) as Total_fours
	    from ipl_ball_by_ball_2008_2020
        where batsman_runs =4
        group by batsman
        order by total_Fours desc
        limit 1 offset 0;
        
-- Ques-12 Write sql query to find the players whose belongs to 3000 runs club and having the highest strike Rate?
     
   select Batsman as PLayers , sum(batsman_runs) as Runs,count(ball) As total_ball_played,
   round(sum(batsman_runs)/count(ball),2)*100 as Strike_Rate 
   from ipl_ball_by_ball_2008_2020  
   where extras_type Not In ('wides' , 'noballs' ,'penalty')
   group by  Batsman 
   having sum(batsman_runs)>=3000 
   order by strike_rate desc;
   
-- Ques-13 Write sql query to find the top 10 players whose have lowest economic rate and has bowled atleat 50 overs?

select bowler , count(ball) as total_balls , (count(ball)/6) as Total_Bowled_overs , sum(total_runs) as runs_given 
,round(sum(total_runs)/(count(ball)/6),2) as economic_rate 
from ipl_ball_by_ball_2008_2020
group by bowler
having (count(ball)/6)>=50
order by economic_rate asc
limit 10 offset 0;

-- Ques-14 Write sql query to find the total match played till 04 seasoned (till 2011)?

select count(distinct id) as Total_Matches from ipl_matches_2008_to_2020
where year(date)  in ('2008', '2009' , '2010' , '2011') ;

-- Ques-15 Write sql query to find the total match win by any team till 2011  04 seasoned ?

select winner as team_name , count(winner) as total_win from ipl_matches_2008_to_2020
where year(date)  in ('2008', '2009' , '2010' , '2011')
group by winner 
order by total_win desc;


-- Ques -16 write sql query to find Which bowler has taken the most wickets in IPL history?

select bowler , count(is_wicket) as Total_wicket  from ipl_ball_by_ball_2008_2020
where is_wicket >0
group by bowler
order by total_wicket desc 
limit 1 offset 0;

-- or 
select bowler , sum(is_wicket) as Total_wicket  from ipl_ball_by_ball_2008_2020
group by bowler
order by total_wicket desc 
limit 1 offset 0;


-- Ques -17 write sql query to find Which team has the highest win percentage in IPL history?

with cte1 as
(select team1 as team , (case when winner =team1 then 1 else 0 end) as result   from ipl_matches_2008_to_2020
union all
select team1 as team ,(case when winner =team2 then 1 else 0 end) as result   from ipl_matches_2008_to_2020)
 , cte2 as 
(select team ,count(1) as Total_Played_Match , sum(result) as win , round(100*sum(result) /count(1),2)  as win_percentage  from cte1 
group by team)
, cte3 as 
(select * , dense_rank() over(partition by team order by win_percentage desc) as rn from cte2 )

select * from cte3 
where rn=1;


-- Ques -18 write sql query to find Which team has won the most IPL championships?


with cte1 as
(select year(date) as year , winner as team , count(winner)as total_match_win_year_wise from ipl_matches_2008_to_2020
group by year , winner 
order by year , total_match_win_year_wise desc)
, cte2 as
(select * , dense_rank() over(partition by year order by total_match_win_year_wise desc  ) as rn 
from cte1)

select team  , count(1) as NUMBER_OF_CHAMPIONS , group_concat(year) As Winning_Years from cte2 
where rn =1
group by team 
order by  NUMBER_OF_CHAMPIONS desc
limit 1 offset 0;
 
 
-- Ques -19 write sql query to find which player is orange cap winner season wise and who won more orange cap ?
with cte1 as
(select year(date) as year ,batsman , sum(batsman_runs) as total_runs from ipl_ball_by_ball_2008_2020  as b
join ipl_matches_2008_to_2020 as m  on m.id =b.id
group by batsman , year(date)
order by year(date) ,total_runs desc)
, cte2 as
(select * , dense_rank() over(partition by year order by total_runs desc) as rn  from cte1 )
 
select Batsman , count(1) as Number_orange_cap_winner , group_concat(year) as winning_years from cte2 
where rn =1
group by batsman 
order by Number_orange_cap_winner  desc
limit 1 offset 0;

 




 
 
    
  
 
    
        
 

 
       


 
