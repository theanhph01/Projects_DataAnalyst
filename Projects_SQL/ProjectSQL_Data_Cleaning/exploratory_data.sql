-- Exploratory Data Analyst
SELECT * 
FROM layoffs_staging2;

SELECT max(total_laid_off), max(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC; 

SELECT company, SUM(total_laid_off), sum(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT min(`date`), max(`date`)
FROM layoffs_staging2;

SELECT industry, sum(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, sum(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT year(`date`), sum(total_laid_off)
FROM layoffs_staging2
GROUP BY year(`date`)
ORDER BY 1 DESC;

SELECT substring(`date`,1,7) AS `month`, sum(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1;

WITH Rolling_Total AS 
(
SELECT substring(`date`,1,7) AS date_time, sum(total_laid_off) AS sum_total
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY date_time
ORDER BY 1
)
SELECT date_time, sum_total,
sum(sum_total) OVER (PARTITION BY substring(`date_time`, 1, 4) ORDER BY date_time) AS rolling_total_by_eachYear,
sum(sum_total) OVER (ORDER BY date_time) AS rolling_total
FROM Rolling_Total;

SELECT company, year(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, year(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, year(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, year(`date`)
)
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off ) AS rank_num
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off ) AS rank_num
FROM Company_Year
WHERE years IS NOT NULL 
AND total_laid_off IS NOT NULL;