-- DATABASE SETUP
CREATE DATABASE housing_analysis;
USE housing_analysis;

-- DATA PREVIEW
select * from cleaned_mumbai_data limit 10;

-- LOCATION BASED ANALYSIS

-- TOP 10 MOST EXPENSIVE LOCALITIES
select locality, avg(price_lakhs) as avg_price
from cleaned_mumbai_data
group by locality
order by avg_price desc
limit 10;

-- TOP 10 MOST AFFORDABLE LOCALITIES
select locality, avg(price_lakhs) as avg_price
from cleaned_mumbai_data
group by locality
order by avg_price asc
limit 10;

-- PROPERTY & BHK ANALYSIS

-- AVERAGE PRICE BY PROPERTY TYPE
select property_type, avg(price_lakhs) as avg_price
from cleaned_mumbai_data
group by property_type;

-- AVERAGE PRICE BY NUMBER OF BEDROOMS (BHK)
select bedroom_num, avg(price_lakhs) as avg_price
from cleaned_mumbai_data
group by bedroom_num
order by bedroom_num;

-- PREMIUM LOCATION ANALYSIS

-- PRICE COMPARISON: PREMIUM VS NON-PREMIUM LOCATIONS
select is_premium_location, avg(price_lakhs) as avg_price
from cleaned_mumbai_data
group by is_premium_location;

-- PRICE & SIZE INSIGHTS

-- TOP 10 HIGHEST PRICED PROPERTIES
select locality, price_lakhs, area
from cleaned_mumbai_data
order by price_lakhs desc
limit 10;

-- TOP 10 LOCALITIES BY PRICE PER SQRT
select locality, avg(price_per_sqft) as avg_psf
from cleaned_mumbai_data
group by locality
order by avg_psf desc
limit 10;

-- ADVANCED ANALYSIS

-- TOP 3 MOST EXPENSIVE PROPERTIES PER LOCALITY
select * from (select locality, price_lakhs, rank() over (partition by locality order by price_lakhs desc) as rnk
       from cleaned_mumbai_data) t
where rnk <= 3;

-- COMPARE EACH PROPERTY WITH LOCALITY AVERAGE
select locality, price_lakhs, avg(price_lakhs) over (partition by locality) as avg_locality_price
from cleaned_mumbai_data;

-- CATEGORIZE PROPERTIES INTO PRICE SEGMENT
select locality, price_lakhs, case when price_lakhs < 100 then 'Low' when price_lakhs < 300 then 'Mid' else 'High' end as price_category
from cleaned_mumbai_data;

-- PRICE DEVIATION FROM LOCALITY AVERAGE
select locality, price_lakhs, price_lakhs - avg(price_lakhs) over (partition by locality) as deviation
from cleaned_mumbai_data;

-- LOCALITIES WITH HIGHEST PRICE RANGE
select locality, max(price_lakhs) - min(price_lakhs) as price_range
from cleaned_mumbai_data
group by locality
order by price_range desc
limit 10;

-- RANK PROPERTIES BY PRICE
select locality, price_lakhs, dense_rank() over (order by price_lakhs desc) as price_rank
from cleaned_mumbai_data;

-- COVARIANCE BETWEEN AREA AND PRICE
select avg(area * price_lakhs) - avg(area) * avg(price_lakhs) as covariance
from cleaned_mumbai_data;

-- DETECT HIGH VALUE OUTLIERS
select * from cleaned_mumbai_data
where price_lakhs > (select avg(price_lakhs) + 2 * STDDEV(price_lakhs) from cleaned_mumbai_data);

-- PERCENTAGE OF PREMIUM LOCATIONS
select is_premium_location, COUNT(*) * 100.0 / (select COUNT(*) from cleaned_mumbai_data) as percentage
from cleaned_mumbai_data
group by is_premium_location;

-- PROPERTIES PRICED ABOVE AVERAGE
select * from cleaned_mumbai_data where price_lakhs > (select avg(price_lakhs) from cleaned_mumbai_data);
