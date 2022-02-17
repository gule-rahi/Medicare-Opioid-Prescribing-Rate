select *
FROM [dbo].[2014]

select *
FROM
	[dbo].[2019]


select AVG(Opioid_Prscrbng_Rate) as average_rate_2014
from [dbo].[2014]


##Average Prescribing Rate in 2014 is 5.90% across all states and territories##

## This includes US territories. Now I want to see the average rate with just states##

## I will use a comparison operator to filter since I know the Prscrb_Desc_Cd greater than 50 are given
to territories##

select AVG(Opioid_Prscrbng_Rate) as avg_state_rate
from [dbo].[2014]
where Prscrbr_Geo_Cd < 51;

##The Average Prescribing Rate not including territories is 6.08% ##



select
	Prscrbr_Geo_Cd, Prscrbr_Geo_Desc, Opioid_Prscrbng_Rate as avg_state_rate
from
	[dbo].[2014]
where 
	Prscrbr_Geo_Cd < 51
order by
	avg_state_rate desc; 




## After 


##Lets find out what state has the highest prescribing rate##


select Prscrbr_Geo_Desc, max(Opioid_Prscrbng_Rate) as max_rate_2014
from [dbo].[2014]
group by Prscrbr_Geo_Desc
order by max_rate_2014 desc




Select Prscrbr_Geo_Desc, Opioid_Prscrbng_Rate
from [dbo].[2014]
where Opioid_Prscrbng_Rate is not null
order by Opioid_Prscrbng_Rate desc

--After exploring, the data data Utah has the highest prescribing rate in 2014 at a rate of 8.37%--


--Joining 2013 and 2019 data and seeing what the change in rate is over the past 6 years--

Select (first.Opioid_Prscrbng_Rate - sec.Opioid_Prscrbng_Rate) as change_rate,
		first.Prscrbr_Geo_Desc
from
	[dbo].[2019] as first
join
	[dbo].[2014] as sec
	on first.Prscrbr_Geo_Desc = sec.Prscrbr_Geo_Desc
order by 
	change_rate desc


--To double check my work I compared the Prescbring Rate for Utah in 2014 to 2019--

Select 
	Prscrbr_Geo_Desc, Opioid_Prscrbng_Rate
from
	[dbo].[2019]
where 
	Prscrbr_Geo_Desc = 'Utah'

--Prescribing Rate for Utah in 2019 is 6.41%. So the difference should be -1.97%--



Select (first.Opioid_Prscrbng_Rate - sec.Opioid_Prscrbng_Rate) as change_rate,
		first.Prscrbr_Geo_Desc as location, first.Prscrbr_Geo_Cd
from
	[dbo].[2019] as first
join
	[dbo].[2015] as sec
	on first.Prscrbr_Geo_Desc = sec.Prscrbr_Geo_Desc
where 
	first.Prscrbr_Geo_Cd < 51
order by 
	change_rate


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


