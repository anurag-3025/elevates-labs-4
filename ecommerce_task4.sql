-- use ecommerce;

-- 1. Basic SELECT with WHERE and ORDER BY
-- Query: Find all TVs with price less than 20000 and rating above 4.5, ordered by rating
select Brand, Resolution, `Size`, `Selling Price`, Rating
from ecommerce
where `Selling Price` < 20000 and Rating > 4.5
order by Rating desc;

-- 2. GROUP BY with aggregate functions
-- Query: Calculate average selling price and count of TVs by brand
select Brand, 
       count(*) as total_models,
       round(avg(`Selling Price`), 2) as avg_price,
       round(AVG(Rating), 2) as avg_rating
from ecommerce
group by Brand
having count(*) > 5
order by avg_price desc;


-- 3. Subquery example
-- Query: Find TVs that are priced higher than the average price for their brand
select e1.Brand, e1.Resolution, e1.`Size`, e1.`Selling Price`
from ecommerce e1
where e1.`Selling Price` > (
    select avg(e2.`Selling Price`)
    from ecommerce e2
    where e2.Brand = e1.Brand
)
order by e1.Brand, e1.`Selling Price`;


-- 4. Creating a View for price analysis
create view price_analysis AS
select 
    Brand,
    Resolution,
    count(*) as model_count,
    round(avg(`Selling Price`), 2) as avg_selling_price,
    round(avg(`Original Price`), 2) as avg_original_price,
    round(avg(`Original Price` - `Selling Price`), 2) as avg_discount
from ecommerce
group by Brand, Resolution;


-- 5. Complex query with multiple conditions
-- Query: Analyze discount percentage by brand and resolution for TVs with ratings > 4
select 
    Brand,
    Resolution,
    COUNT(*) as total_models,
    ROUND(AVG(`Selling Price`), 2) as avg_selling_price,
    ROUND(AVG(`Original Price`), 2) as avg_original_price,
    ROUND(((AVG(`Original Price`) - AVG(`Selling Price`))/AVG(`Original Price`) * 100), 2) as discount_percentage
from ecommerce
where Rating > 4
group by Brand, Resolution
having COUNT(*) > 3
order by discount_percentage desc;



-- 6. Size distribution analysis
select 
    case 
        when `Size` <= 32 then 'Small (≤32)'
        when `Size` <= 43 then 'Medium (33-43)'
        when `Size` <= 55 then 'Large (44-55)'
        else 'Extra Large (>55)'
    end as size_category,
    count(*) as total_models,
    round(avg(`Selling Price`), 2) as avg_price,
    round(avg(Rating), 2) as avg_rating
from ecommerce
group by size_category
order by avg_price;


-- 7. Operating System Market Analysis
select 
    `Operating System`,
    count(*) as total_models,
    round(avg(`Selling Price`), 2) as avg_price,
    round(avg(Rating), 2) as avg_rating,
    count(distinct Brand) as number_of_brands
from ecommerce
where `Operating System` is not null
group by `Operating System`
order by total_models desc;



-- 8. Create an index for better performance
create index idx_brand_price on ecommerce(Brand, `Selling Price`);


-- 9. Price Range Distribution
select 
    case 
        when `Selling Price` <= 15000 then 'Budget (≤15K)'
        when `Selling Price` <= 30000 then 'Mid-Range (15K-30K)'
        when `Selling Price` <= 50000 then 'Premium (30K-50K)'
        else 'Luxury (>50K)'
    end as price_category,
    COUNT(*) as total_models,
    ROUND(avg(Rating), 2) as avg_rating,
    COUNT(distinct Brand) as number_of_brands
from ecommerce
group by price_category
order by total_models desc;


-- 10. Best Value Analysis
select 
    Brand,
    Resolution,
    `Size`,
    `Selling Price`,
    Rating,
    ROUND(`Selling Price`/Rating, 2) as price_per_rating_point
from ecommerce
where Rating > 4
order by price_per_rating_point asc
limit 10;