--created a table and imported the data from the excel dataset with all columns as text.

--changing the column name and data type for the id column:

alter table hr
rename column id to emp_id;

alter table hr
alter column emp_id type varchar(20);

/*updating the data in the birthdate and hire_date columns to the standard date format of 'YYYY-MM-DD'. Currently, it is a mix containing '/'
or '-' in 'mm-dd-yy' or 'mm/dd/yyyy'. Also, altering the data types of these columns*/.

update hr
set birthdate = case when birthdate like '%/%' then to_char(to_date(birthdate, 'MM/DD/YYYY'), 'YYYY-MM-DD')
					 when birthdate like '%-%' then to_char(to_date(birthdate, 'MM-DD-YY'), 'YYYY-MM-DD')
					 else null end;
					 
update hr
set hire_date = case when hire_date like '%/%' then to_char(to_date(hire_date, 'MM/DD/YYYY'), 'YYYY-MM-DD')
					 when hire_date like '%-%' then to_char(to_date(hire_date, 'MM-DD-YY'), 'YYYY-MM-DD')
					 else null end;

alter table hr
alter column birthdate type date
using (birthdate::date);

alter table hr
alter column hire_date type date
using (hire_date::date);

/*The text data in the termdate column is in the format 'YYYY-MM-DD HH:MM:SS TMZ'. So, we will cast it as date only as we do not need the
timestamp and timezone in our analysis. We will also change the datatype of the column from text to date*/

update hr
set termdate = termdate::date
where termdate is not null and termdate != '';

alter table hr
alter column termdate type date
using (termdate::date);

--Adding an 'Age' column (calculated).

alter table hr
add column age int;

update hr
set age = extract(year from age(current_date, birthdate))