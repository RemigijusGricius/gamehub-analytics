

    SELECT
        order_id,
        COUNT(*) AS record_count
    FROM read_csv_auto('data/raw/orders.csv')
    GROUP BY order_id
    HAVING COUNT(*) > 1;

