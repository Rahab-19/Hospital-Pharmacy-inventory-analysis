-- 1.Missing values
SELECT
    SUM(CASE WHEN medicine_name IS NULL THEN 1 ELSE 0 END)
        AS missing_medicine_names,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END)
        AS missing_categories,
    SUM(CASE WHEN reorder_level IS NULL THEN 1 ELSE 0 END)
        AS missing_reorder_levels,
    SUM(CASE WHEN unit_cost IS NULL THEN 1 ELSE 0 END)
        AS missing_unit_costs
FROM medicines;

-- 2.Duplicate medicine names
SELECT
    medicine_name,
    COUNT(*) AS duplicate_count
FROM medicines
GROUP BY medicine_name
HAVING COUNT(*) > 1;

-- 3.Invalide stock quantities and usage
SELECT *
FROM inventory
WHERE qty_on_hand < 0;

SELECT *
FROM usage_transactions
WHERE qty_used <= 0;

-- 4.Expired inventory batches
SELECT
    stock_id,
    medicine_id,
    batch_no,
    qty_on_hand,
    expiry_date
FROM inventory
WHERE expiry_date < TRUNC(SYSDATE)
ORDER BY expiry_date;

-- 5.Batches expiring within the next 90 days
SELECT
    stock_id,
    medicine_id,
    batch_no,
    qty_on_hand,
    expiry_date
FROM inventory
WHERE expiry_date >= TRUNC(SYSDATE)
  AND expiry_date < TRUNC(SYSDATE) + 90
ORDER BY expiry_date;

-- 6.Medicines without inventory records
SELECT
    m.medicine_id,
    m.medicine_name
FROM medicines m
LEFT JOIN inventory i
    ON m.medicine_id = i.medicine_id
WHERE i.stock_id IS NULL;

-- 7.Medicines without usage transactions
SELECT
    m.medicine_id,
    m.medicine_name
FROM medicines m
LEFT JOIN usage_transactions u
    ON m.medicine_id = u.medicine_id
WHERE u.transaction_id IS NULL;

-- 8. Future-dated usage transactions
SELECT *
FROM usage_transactions
WHERE transaction_date > SYSDATE
ORDER BY transaction_date;