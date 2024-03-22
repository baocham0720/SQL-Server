--CREATE DATABASE BikeStores 

-- Lấy tất cả dữ liệu có trong Table
SELECT * FROM brands

--Lấy các cột cụ thể
SELECT brand_id, brand_name FROM dbo.brands

-- Lấy với một biểu thức
SELECT * FROM customers 
SELECT customer_id, first_name + '' + last_name AS full_name FROM dbo.customers

--Select without from
SELECT GETDATE()
SELECT UPPER('chu thuong')

--DISTINCT : loại bỏ giá trị trùng lặp
SELECT * FROM orders
SELECT DISTINCT customer_id FROM orders 
SELECT 
DISTINCT
     customer_id
FROM 
     orders
ORDER BY 
     customer_id ASC

--Câu lệnh TOP & PERCENT
--TOP : lấy 10 dòng đầu tiên trong dữ liệu đang có
SELECT TOP 10 * FROM orders
--PERCENT : 5, tức là lấy 5% dữ liệu ngẫu nhiên
SELECT TOP 5 PERCENT * FROM orders

--TOP with TIES : thêm 1 dòng thành dòng sô 11 nữa
SELECT TOP 10 WITH TIES product_id, product_name, price 
FROM products
ORDER BY price DESC

--Select INTO : Lấy thêm dữ liệu đổ vào và sao chép thành table mới y chang talbe cũ
SELECT * INTO customersBackup2019
FROM customers;
SELECT * FROM customersBackup2019 -- được coi như là một bảng dự phòng

--Select with WHERE : lấy cái gì từ đâu và phạm vi là như thế nào ở đâu
SELECT
     * 
FROM 
     customers  
WHERE 
     customer_id = 5
--ex: lấy cho tôi sản phẩm có giá > 2000
SELECT
     * 
FROM 
     products
WHERE 
     price > 2000 
--ex: lấy cho tôi sản phẩm có giá > 2000 và model_year=2019
SELECT
     * 
FROM 
     products 
WHERE 
     price > 2000 AND model_year = 2019
--ex: Lấy cho tôi sản phẩm có brand_id=5 hoặc brand_id=8
SELECT
     * 
 FROM
      products 
WHERE 
     brand_id=5 OR brand_id=8

--Toán tử IN: tương đương với OR
SELECT
      * 
FROM 
     products
WHERE
     brand_id IN (5,8) --dùng cho dữ liệu ít, còn nhiều dùng OR nhanh hơn

-- Vừa OR vừa AND
--ex: Lấy cho tôi sản phẩm có brand_id=5 hoặc brand_id=8 và category_id=4
SELECT
    *
FROM
    products
WHERE
    (brand_id=5 OR brand_id=8) AND category_id=4 --nhiều toán tử cùng lúc thì thêm ()

--Toán tử BETWEEN : Khỏang cách từ ngày này đến ngày kia
--ex: tìm đơn hàng từ 2016-01-01 đến 2016-05-01
SELECT
     * 
FROM 
    orders
WHERE  
    order_date >= '2016-01-01'
    AND
    order_date <= '2016-05-01'
--cách 2:
SELECT 
    *
FROM
    orders
WHERE
    order_date BETWEEN CONVERT(DATE, '2016-01-01') AND CONVERT(DATE, '2016-05-01')

-- Toán tử LIKE : tìm kiếm định dạng
--ex: tìm ra khách hàng có số đuôi 478
SELECT
    *
FROM 
    customers
WHERE
    phone LIKE '%478'
--ex: tìm khách hàng có sinh năm 1972
SELECT
    *
FROM 
    customers
WHERE
    birthday LIKE '1972%'

--Muốn sắp xếp theo trật từ tăng hoặc giảm dần thì nối thêm Lệnh
--ORDER BY ( ASC : tăng , DESC : giảm)
SELECT
    *
FROM 
    customers
WHERE
    birthday LIKE '1972%'
ORDER BY customer_id DESC

-- SELECT với mệnh đề ROWS OFFSET, FETCH NEXT
SELECT
    product_id,
    product_name,
    price
FROM
    dbo.products
ORDER BY
    price,
    product_id,
    product_name
OFFSET 10 ROWS --vị trí bắt đầu lấy
--1-10 là page 1
SELECT
    product_id,
    product_name,
    price
FROM   
    dbo.products
ORDER BY
    product_id,
    price,
    product_name
OFFSET 0 ROWS --bắt đầu lấy từ vị trí số 0
FETCH NEXT 10 ROWS ONLY --lấy 10 dòng tiếp theo
--10-20 là page 2
SELECT
    product_id,
    product_name,
    price
FROM
    dbo.products
ORDER BY
    product_id,
    product_name,
    price
OFFSET 10 ROWS --bắt đầu từ vị trí thứ 11
FETCH NEXT 10 ROWS ONLY

--SELECT với mệnh đề GROUP BY : select có bao nhiêu trường thì đưa hết vào group by
--ex: lấy tát cả các mức giảm giá discount của sp theo thứ tự tăng dần
SELECT
    discount,
    COUNT (product_id) 
FROM
    products
GROUP BY
    discount,
    product_name
ORDER BY
    discount ASC
SELECT * FROM products WHERE discount = 26 -- select all để kiểm tra chéo
SELECT * FROM products WHERE discount = 0.1

--Hoặc 
SELECT
    brand_name,
    MIN(price) min_price,
    MAX(price) max_price
FROM
    dbo.products p
INNER JOIN dbo.brands b ON b.brand_id = p.brand_id
WHERE
    model_year = 2018
GROUP BY
    brand_name
ORDER BY
    brand_name
