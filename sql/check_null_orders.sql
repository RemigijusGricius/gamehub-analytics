SELECT
    COUNT(*) AS null_order_ids
FROM read_csv_auto('data/raw/orders.csv')
WHERE order_id IS NULL;