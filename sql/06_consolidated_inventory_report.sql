
WITH stock_summary AS (
    SELECT
        i.medicine_id,
        SUM(i.qty_on_hand) AS total_stock,
        SUM(i.qty_on_hand * m.unit_cost) AS inventory_value,
        SUM(
            CASE
                WHEN i.expiry_date >= TRUNC(SYSDATE)
                 AND i.expiry_date < TRUNC(SYSDATE) + 90
                THEN i.qty_on_hand
                ELSE 0
            END
        ) AS units_expiring_within_90_days
    FROM inventory i
    JOIN medicines m
        ON i.medicine_id = m.medicine_id
    GROUP BY i.medicine_id
),
usage_summary AS (
    SELECT
        medicine_id,
        SUM(qty_used) AS total_units_used,
        COUNT(*) AS transaction_count
    FROM usage_transactions
    GROUP BY medicine_id
)
SELECT
    m.medicine_id,
    m.medicine_name,
    m.category,
    m.reorder_level,
    NVL(s.total_stock, 0) AS total_stock,
    CASE
        WHEN NVL(s.total_stock, 0) = 0
            THEN 'OUT OF STOCK'
        WHEN NVL(s.total_stock, 0) < m.reorder_level
            THEN 'LOW STOCK'
        ELSE 'SUFFICIENT STOCK'
    END AS stock_status,
    NVL(s.inventory_value, 0) AS inventory_value,
    NVL(s.units_expiring_within_90_days, 0)
        AS units_expiring_within_90_days,
    NVL(u.total_units_used, 0) AS total_units_used,
    NVL(u.transaction_count, 0) AS transaction_count
FROM medicines m
LEFT JOIN stock_summary s
    ON m.medicine_id = s.medicine_id
LEFT JOIN usage_summary u
    ON m.medicine_id = u.medicine_id
ORDER BY inventory_value DESC;
