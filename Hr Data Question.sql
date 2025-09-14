-- Questions

-- 1. what is the gender breakdown of employees in the company?
select gender, count(*) count
from hr
where age >= 18 and termdate is null
group by gender;

-- 2. what is the race/ethnicity breakdown of employees in the company?
select race, count(*) count
from hr
where age >= 18 and termdate is null
group by race
order by count(*) desc;

-- 3. what is the age distribution of employees in the company?
select 
    min(age) youngest,
    max(age) oldest
from hr
where age >= 18 and termdate is null;

-- 4. how many employees work at headquarters versus remote locations?
select
	case
		when age >=18 and age <=24 then '18-24'
        when age >=25 and age <=34 then '25-34'
		when age >=35 and age <=44 then '35-44'
		when age >=45 and age <=54 then '45-54'
		when age >=55 and age <=64 then '55-64'
        else '65+'
	end as age_group,
    count(*) as count
from hr
where age >= 18 and termdate is null
group by age_group
order by age_group;

select
	case
		when age >=18 and age <=24 then '18-24'
        when age >=25 and age <=34 then '25-34'
		when age >=35 and age <=44 then '35-44'
		when age >=45 and age <=54 then '45-54'
		when age >=55 and age <=64 then '55-64'
        else '65+'
	end as age_group,gender,
    count(*) as count
from hr
where age >= 18 and termdate is null
group by age_group,gender
order by age_group,gender;

select location, count(*) as count
from hr
where age >= 18 and termdate is null
group by location;

-- 5. what is the average length of employment for employees who have been terminated?
select
	 round(avg(datediff(termdate,hire_date))/365,0) as avg_length_employement
from hr
where termdate <= curdate() and termdate <> is null and age>= 18;

select
  round(avg(datediff(termdate, hire_date) / 365.0), 0) as avg_length_employment_years
from hr
where termdate is not null
  and hire_date is not null
  and termdate <= curdate()
  and age >= 18;

-- 6. how does the gender distribution vary across departments and job titles?
select department,gender, count(*) as count
from hr
where age >= 18 and termdate is null
group by department,gender
order by department;

-- 7. what is the distribution of job titles across the company?
select jobtitle, count(*) as count
from hr
where age >= 18 and termdate is null
group by jobtitle
order by jobtitle desc;

-- 8. which department has the highest turnover rate?
select 
    department,
    count(*) as total_count,
    sum(case 
            when termdate is not null 
                 and termdate <= curdate() 
            then 1 else 0 
        end) as terminated_count,
    round(sum(case 
                 when termdate is not null 
                      and termdate <= curdate() 
                 then 1 else 0 
             end) * 1.0 / count(*), 4) as turnover_rate
from hr
where age >= 18   -- hanya hitung karyawan valid
group by department
order by turnover_rate desc;

-- 9. what is the distribution of employees across locations by city and state?
select location_state, count(*) as count
from hr
where age >= 18 and termdate is null
group by location_state
order by count desc;

-- 10. how has the company's employee count changed over time based on hire and term dates?
select
    year,
    hires,
    terminations,
    hires - terminations as net_change,
    round((hires - terminations) / hires * 100, 2) as net_change_percent
from (
    select
        year(hire_date) as year,
        count(*) as hires,
        sum(case 
                when str_to_date(termdate, '%Y-%m-%d') is not null
                     and str_to_date(termdate, '%Y-%m-%d') <= curdate()
                then 1 else 0
            end) as terminations
    from hr
    where age >= 18
    group by year(hire_date)
) as subquery
order by year asc
limit 0, 1000;

-- 11. what is the tenure distribution for each department?
select 
    department,
    round(avg(datediff(str_to_date(termdate, '%Y-%m-%d'), hire_date) / 365), 0) as avg_tenure
from hr
where termdate not in ('0000-00-00', '')
  and age >= 18
  and str_to_date(termdate, '%Y-%m-%d') <= curdate()
group by department;
