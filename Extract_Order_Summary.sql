SET @begin_date = '2018-01-01';
SET @end_date = '2023-08-01';

select
    p.ID as order_id,
    p.post_date,
    MAX(CASE WHEN pm.meta_key = '_shipping_city' AND p.ID = pm.post_id THEN pm.meta_value END) AS _shipping_city,
    MAX(CASE WHEN pm.meta_key = '_shipping_country' AND p.ID = pm.post_id THEN pm.meta_value END) AS _shipping_country,
    MAX(CASE WHEN pm.meta_key = '_shipping_postcode' AND p.ID = pm.post_id THEN pm.meta_value END) AS _shipping_postcode,
    MAX(CASE WHEN pm.meta_key = '_order_total' AND p.ID = pm.post_id THEN pm.meta_value END) AS order_total,
    MAX(CASE WHEN pm.meta_key = '_order_tax' AND p.ID = pm.post_id THEN pm.meta_value END) AS order_tax,
    MAX(CASE WHEN pm.meta_key = '_order_shipping' AND p.ID = pm.post_id THEN pm.meta_value END) AS _order_shipping,
    MAX(CASE WHEN pm.meta_key = '_paid_date' AND p.ID = pm.post_id THEN pm.meta_value END) AS paid_date,
    ( select group_concat( order_item_name separator '|' ) FROM wp_woocommerce_order_items WHERE order_id = p.ID) AS order_items
FROM
    wp_posts p 
    JOIN wp_postmeta pm on p.ID = pm.post_id
    JOIN wp_woocommerce_order_items oi on p.ID = oi.order_id
WHERE
    p.post_type = 'shop_order'
    AND p.post_date BETWEEN @begin_date AND @end_date 
	 AND p.post_status = 'wc-completed'
GROUP BY
    p.ID