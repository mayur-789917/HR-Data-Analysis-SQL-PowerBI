-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?

select gender, count(*) as ct
from hr
where termdate is null or termdate > current_date
group by gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?

select race, count(*) as ct
from hr
where termdate is null or termdate > current_date
group by race
order by ct desc;

-- 3. What is the age distribution of employees by gender in the company?
-- Note: There is no employee less than 18 years of age in the company.

select case when age>=18 and age<=24 then '18-24'
			when age>=25 and age<=34 then '25-34'
			when age>=35 and age<=44 then '35-44'
			when age>=45 and age<=54 then '45-54'
			when age>=55 and age<=64 then '55-64'
			else '65+'
	    end as age_group,
		gender,
		count(*) as ct
from hr
where termdate is null or termdate > current_date
group by age_group, gender
order by age_group, gender;

-- 4. How many employees work at headquarters versus remote locations?

select location, count(*) as ct
from hr
where termdate is null or termdate > current_date
group by location;

-- 5. What is the average length of employment for employees who have been terminated?

select round(avg((termdate - hire_date)*1.00/365),2) as avg_length_employment
from hr
where termdate <= current_date;

-- 6. How does the gender distribution vary across departments and job titles?

select department, gender, count(*) as ct
from hr
where termdate is null or termdate > current_date
group by department, gender
order by department, gender;

select jobtitle, gender, count(*) as ct
from hr
where termdate is null or termdate > current_date
group by jobtitle, gender
order by jobtitle, gender;

-- 7. What is the distribution of job titles across the company?

select jobtitle, count(*) as ct
from hr
where termdate is null or termdate > current_date
group by jobtitle
order by jobtitle desc;

-- 8. Which department has the highest turnover rate?

select department,
	   total_emp_count,
	   terminated_emp_count,
	   round((terminated_emp_count*100.00/total_emp_count),2) as turnover_rate
from 
	   (select department,
	   	 	   count(*) as total_emp_count,
	   		   sum(case when termdate <= current_date and termdate is not null then 1
				   		else 0
				   end) as terminated_emp_count
		from hr
		group by department
	   ) subquery
order by turnover_rate desc
limit 1;

-- 9. What is the distribution of employees across locations by state?

select location_state, count(*) as ct
from hr
where termdate is null or termdate > current_date
group by location_state
order by ct desc;

-- 10. How has the company's employee count changed over time based on hire and term dates in the time period from 2000-2020?

select year,hires,terminations, net_change, total_emp_ct,
	   round(net_change*100/lag(total_emp_ct) over (order by year), 2) as percent_change
from
(select year,
	   hires,
	   terminations,
	   hires-terminations as net_change,
	   sum(hires-terminations) over (order by year) as total_emp_ct
from
	   (select extract(year from hire_date) as year,
			   count(hire_date) as hires,
			   sum(case when termdate is not null and extract(year from termdate)=extract(year from hire_date) then 1 
				   else 0 end) as terminations
		from hr
		group by extract(year from hire_date)
	   ) subquery
order by year asc) sq2;

-- 11. What is the average tenure distribution for each department?

select department, round(avg((termdate-hire_date)/365)) as avg_tenure
from hr
where termdate is not null and termdate <= current_date
group by department;