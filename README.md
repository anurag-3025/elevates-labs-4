verview
This project demonstrates SQL data analysis on an ecommerce TV sales dataset. The analysis covers a range of SQL concepts including filtering, aggregation, subqueries, views, and indexing, using a table created from Ecommerce.csv.

Database Used: MySQL (compatible with PostgreSQL/SQLite with minor syntax changes)

Dataset: Ecommerce.csv (TV sales data)

Dataset Structure
The table ecommerce was created from the following columns:

Brand
Resolution
Size
Selling Price
Original Price
Operating System
Rating
SQL Tasks & Queries
1. Basic SELECT with WHERE and ORDER BY
Purpose: Find all TVs with price less than 20,000 and rating above 4.5, ordered by rating.

SELECT Brand, Resolution, `Size`, `Selling Price`, Rating
FROM ecommerce
WHERE `Selling Price` < 20000 AND Rating > 4.5
ORDER BY Rating DESC;
2. GROUP BY with Aggregate Functions
Purpose: Calculate average selling price and count of TVs by brand.

SELECT Brand, 
       COUNT(*) as total_models,
       ROUND(AVG(`Selling Price`), 2) as avg_price,
       ROUND(AVG(Rating), 2) as avg_rating
FROM ecommerce
GROUP BY Brand
HAVING COUNT(*) > 5
ORDER BY avg_price DESC;
3. Subquery Example
Purpose: Find TVs that are priced higher than the average price for their brand.

SELECT e1.Brand, e1.Resolution, e1.`Size`, e1.`Selling Price`
FROM ecommerce e1
WHERE e1.`Selling Price` > (
    SELECT AVG(e2.`Selling Price`)
    FROM ecommerce e2
    WHERE e2.Brand = e1.Brand
)
ORDER BY e1.Brand, e1.`Selling Price`;
4. Creating a View for Price Analysis
Purpose: Create a view to analyze average prices and discounts by brand and resolution.

CREATE VIEW price_analysis AS
SELECT 
    Brand,
    Resolution,
    COUNT(*) as model_count,
    ROUND(AVG(`Selling Price`), 2) as avg_selling_price,
    ROUND(AVG(`Original Price`), 2) as avg_original_price,
    ROUND(AVG(`Original Price` - `Selling Price`), 2) as avg_discount
FROM ecommerce
GROUP BY Brand, Resolution;
5. Complex Query with Multiple Conditions
Purpose: Analyze discount percentage by brand and resolution for TVs with ratings > 4.

SELECT 
    Brand,
    Resolution,
    COUNT(*) as total_models,
    ROUND(AVG(`Selling Price`), 2) as avg_selling_price,
    ROUND(AVG(`Original Price`), 2) as avg_original_price,
    ROUND(((AVG(`Original Price`) - AVG(`Selling Price`))/AVG(`Original Price`) * 100), 2) as discount_percentage
FROM ecommerce
WHERE Rating > 4
GROUP BY Brand, Resolution
HAVING COUNT(*) > 3
ORDER BY discount_percentage DESC;
6. Size Distribution Analysis
Purpose: Analyze TV size categories and their average price and rating.

SELECT 
    CASE 
        WHEN `Size` <= 32 THEN 'Small (≤32)'
        WHEN `Size` <= 43 THEN 'Medium (33-43)'
        WHEN `Size` <= 55 THEN 'Large (44-55)'
        ELSE 'Extra Large (>55)'
    END as size_category,
    COUNT(*) as total_models,
    ROUND(AVG(`Selling Price`), 2) as avg_price,
    ROUND(AVG(Rating), 2) as avg_rating
FROM ecommerce
GROUP BY size_category
ORDER BY avg_price;
7. Operating System Market Analysis
Purpose: Analyze the popularity and average price/rating of TVs by operating system.

SELECT 
    `Operating System`,
    COUNT(*) as total_models,
    ROUND(AVG(`Selling Price`), 2) as avg_price,
    ROUND(AVG(Rating), 2) as avg_rating,
    COUNT(DISTINCT Brand) as number_of_brands
FROM ecommerce
WHERE `Operating System` IS NOT NULL
GROUP BY `Operating System`
ORDER BY total_models DESC;
8. Index Creation for Performance
Purpose: Optimize queries filtering by brand and price.

CREATE INDEX idx_brand_price ON ecommerce(Brand, `Selling Price`);
To view all indexes:

SHOW INDEXES FROM ecommerce;
9. Price Range Distribution
Purpose: Analyze the distribution of TVs by price category.

SELECT 
    CASE 
        WHEN `Selling Price` <= 15000 THEN 'Budget (≤15K)'
        WHEN `Selling Price` <= 30000 THEN 'Mid-Range (15K-30K)'
        WHEN `Selling Price` <= 50000 THEN 'Premium (30K-50K)'
        ELSE 'Luxury (>50K)'
    END as price_category,
    COUNT(*) as total_models,
    ROUND(AVG(Rating), 2) as avg_rating,
    COUNT(DISTINCT Brand) as number_of_brands
FROM ecommerce
GROUP BY price_category
ORDER BY total_models DESC;
10. Best Value Analysis
Purpose: Find TVs with the best price-to-rating ratio.

SELECT 
    Brand,
    Resolution,
    `Size`,
    `Selling Price`,
    Rating,
    ROUND(`Selling Price`/Rating, 2) as price_per_rating_point
FROM ecommerce
WHERE Rating > 4
ORDER BY price_per_rating_point ASC
LIMIT 10;
