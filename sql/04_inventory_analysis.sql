-- 1.Current stock levels and reorder status
SELECT
    m.medicine_id,
    m.medicine_name,
    m.category,
    m.reorder_level,
    NVL(SUM(i.qty_on_hand), 0) AS total_stock,
    CASE
        WHEN NVL(SUM(i.qty_on_hand), 0) = 0
            THEN 'OUT OF STOCK'
        WHEN NVL(SUM(i.qty_on_hand), 0) < m.reorder_level
            THEN 'LOW STOCK'
        ELSE 'SUFFICIENT STOCK'
    END AS stock_status
FROM medicines m
LEFT JOIN inventory i
    ON m.medicine_id = i.medicine_id
GROUP BY
    m.medicine_id,
    m.medicine_name,
    m.category,
    m.reorder_level
ORDER BY total_stock ASC;


-- 2. Total inventory value
SELECT
    m.medicine_id,
    m.medicine_name,
    m.category,
    NVL(SUM(i.qty_on_hand), 0) AS total_stock,
    m.unit_cost,
    NVL(SUM(i.qty_on_hand * m.unit_cost), 0)
        AS inventory_value
FROM medicines m
LEFT JOIN inventory i
    ON m.medicine_id = i.medicine_id
GROUP BY
    m.medicine_id,
    m.medicine_name,
    m.category,
    m.unit_cost
ORDER BY inventory_value DESC;


-- 3.Total stock value by category
SELECT
    m.category,
    SUM(i.qty_on_hand) AS total_units,
    SUM(i.qty_on_hand * m.unit_cost) AS total_inventory_value
FROM medicines m
JOIN inventory i
    ON m.medicine_id = i.medicine_id
GROUP BY m.category
ORDER BY total_inventory_value DESC;


-- 4.Most-used medicines
SELECT
    m.medicine_name,
    m.category,
    SUM(u.qty_used) AS total_units_used,
    COUNT(u.transaction_id) AS transaction_count
FROM medicines m
JOIN usage_transactions u
    ON m.medicine_id = u.medicine_id
GROUP BY
    m.medicine_name,
    m.category
ORDER BY total_units_used DESC;


-- 5.Monthly usage trends
SELECT
    TRUNC(transaction_date, 'MM') AS usage_month,
    SUM(qty_used) AS total_units_used,
    COUNT(*) AS transaction_count
FROM usage_transactions
GROUP BY TRUNC(transaction_date, 'MM')
ORDER BY usage_month;