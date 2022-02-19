---Data exploration of Opioid Data sets. Since we have data sets from 2014-2019.
--We will combine tables and do some analysis for visualization


select *
from [dbo].[2014]

--This table has 2 results for Opioid Presribing Rate so we will take an average of both results and create a new table


select 
	avg(Opioid_Prscrbng_Rate) as Prescribing_rate, Prscrbr_Geo_Desc, Prscrbr_Geo_Cd 
into new2014

FROM [dbo].[2014]

group by Prscrbr_Geo_Desc, Prscrbr_Geo_Cd

--To make sure we executed the code properly we will check our work by pulling the new2014 table--

select *
from [dbo].[new2014]



select AVG(Prescribing_rate) as average_rate_2014
from [dbo].[new2014]


--Average Prescribing Rate in 2014 is 5.75% across all states and territories##

--This includes US territories. Now I want to see the average rate with just states

--I will use a comparison operator to filter since I know the Prscrb_Desc_Cd greater than 50 are given to territories
  
select AVG(Prescribing_rate) as avg_state_rate
from [dbo].[new2014]
where Prscrbr_Geo_Cd < 51;

--The Average Prescribing Rate not including territories is 6.04%

--Lets find out what state has the highest prescribing rate--

select
	Prscrbr_Geo_Cd, Prscrbr_Geo_Desc, Prescribing_rate
from
	[dbo].[new2014]
where 
	Prscrbr_Geo_Cd < 51
order by
	Prescribing_rate desc; 


--After exploring, the dataset Utah has the highest prescribing rate in 2014 at a rate of 8.13%--


--Joining 2014 and 2019 data and seeing what the change in  prescribing rate is over the past 5 years in just the states--

Select (first.Opioid_Prscrbng_Rate - sec.Prescribing_rate) as change_rate,
		first.Prscrbr_Geo_Desc
from
	[dbo].[2019] as first
join
	[dbo].[new2014] as sec
	on first.Prscrbr_Geo_Desc = sec.Prscrbr_Geo_Desc

where first.Prscrbr_Geo_Cd < 51
order by 
	change_rate




--To double check my work I compared the Prescbring Rate for Utah in 2014 to 2019.
--The change rate for Utah is -1.72%. Let's double check our work to make sure the data is consistent--

Select 
	Prscrbr_Geo_Desc, Opioid_Prscrbng_Rate
from
	[dbo].[2019]
where 
	Prscrbr_Geo_Desc = 'Utah'

--Prescribing rate for Utah in 2019 is 6.41%


Select 
	Prscrbr_Geo_Desc, Prescribing_rate
from
	[dbo].[new2014]
where 
	Prscrbr_Geo_Desc = 'Utah'

--Prescribing rate for Utah in 2014 is 8.13%--

--Prescribing Rate for Utah in 2019 is 6.41%. So the difference should be -1.97%--




	--Creating view to store data for later visualization---

Create View ChangePrescriberRate as
Select (first.Opioid_Prscrbng_Rate - sec.Opioid_Prscrbng_Rate) as change_rate,
		first.Prscrbr_Geo_Desc as location, first.Prscrbr_Geo_Cd
from
	[dbo].[2019] as first
join
	[dbo].[2015] as sec
	on first.Prscrbr_Geo_Desc = sec.Prscrbr_Geo_Desc
where 
	first.Prscrbr_Geo_Cd < 51
--order by change_rate


