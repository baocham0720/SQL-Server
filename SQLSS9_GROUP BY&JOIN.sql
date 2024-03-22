-- GROUP BY với WHERE
--ex: Liệt kê danh sách giảm giá của những sản phẩm có giá trên 2000
SELECT * FROM products 
SELECT
    discount,
    COUNT (product_id) AS Total -- Điểm dựa vào ID và đặt tên là Total
FROM 
    products
WHERE 
    price > 2000
GROUP BY
    discount
ORDER BY
    discount ASC

--GROUP BY với NULL : những thông tin không điền thì sẽ là NULL
--ex: Lấy danh sách thành phố của khách hàng đã đặt hàng
SELECT * FROM orders
SELECT
    shipping_city
FROM 
    orders
GROUP BY
    shipping_city
ORDER BY
    shipping_city

--GROUP BY với ALL : gom nhóm những giữ nguyên dữ liệu cả gía trị trùng lặp
SELECT 
    order_id,
    customer_id,
    SUM (order_amount) AS TotalAmount
FROM
    orders
GROUP BY ALL
    order_id,
    customer_id

--GROUP BY với HAVING : lọc ra những thông tin cần lấy
SELECT 
    order_id,
    customer_id,
    SUM (order_amount) AS TotalAmount
FROM
    orders
GROUP BY ALL
    order_id,
    customer_id
HAVING
    SUM (order_amount) > 15000

--tạo thư mục dbo.sales_summary
SELECT
    b.brand_name AS brand,
    c.category_name AS category,
    p.model_year,
    round(
        SUM (
            i.quantity * i.price * (1 - i.discount)
        ),
        0
    ) sales INTO dbo.sales_summary
FROM
    dbo.order_items i
INNER JOIN dbo.products p ON p.product_id = i.product_id
INNER JOIN dbo.brands b ON b.brand_id = p.brand_id
INNER JOIN dbo.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year
ORDER BY
    b.brand_name,
    c.category_name,
    p.model_year;

--GROUP BY với SETS : cho phép nhóm dữ liệu theo nhiều tập hợp khác nhau trong một câu truy vấn duy nhất
--ex: Truy vấn trả về số tiền bán được nhóm theo thương hiệu và danh mục
--Khi nhóm cả category và brand
SELECT * FROM sales_summary
SELECT
    brand,
    category,
    SUM (sales) AS sales
FROM
    dbo.sales_summary
GROUP BY
    brand,
    category
ORDER BY
    brand,
    category
--Khi chỉ nhóm theo brand (thương hiệu) 
SELECT
    brand,
    SUM (sales) AS sales
FROM
    dbo.sales_summary
GROUP BY
    brand
ORDER BY
    brand
--Khi chỉ nhóm theo category (danh mục)
SELECT 
    category
FROM 
    dbo.sales_summary
GROUP BY
    category
ORDER BY
    category
-- Khi nhóm tổng doanh thu (báo cáo tổng hợp)
SELECT
    SUM (sales) sales
FROM
    dbo.sales_summary
--Khi có GROUPING SETS giúp thu gọi lệnh vẫn cho ra kết quả
SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    dbo.sales_summary
GROUP BY
    GROUPING SETS (   -- muốn tạo ra bao nhiêu nhóm thì ()
        (brand, category),
        (brand),
        (category), 
        ()
    )
ORDER BY
    brand,
    category

--GROUP BY với CUBE : là cú pháp ngắn gọn hơn GROUPING SETS
SELECT
    brand,
    category,
    SUM (sales) sales 
FROM
    dbo.sales_summary
GROUP BY
    CUBE (brand, category) -- rút ngắn thay vì phải liệt kê nhiều nhóm như GROUPING SETS
ORDER BY
    brand,
    category

--GROUP BY với ROLLUP : theo mảng phân cấp và chỉ tạo nhóm dựa trên phân cấp này,
SELECT
    brand, 
    category,
    SUM (sales) sales 
FROM
    dbo.sales_summary
GROUP BY
    ROLLUP (brand, category)

--AGGREGATE FUNCTION
--Dùng COUNT : là để ĐẾM số lượng bản ghi trong một nhóm
--ex: Đếm số lượng sản phẩm theo từng loại giá
SELECT
    price,
    COUNT (product_id) AS 'NumberOfProducts'
FROM
    products
GROUP BY
    price
--check chéo : 
SELECT * FROM products WHERE price = 149.99
--Dùng SUM : là để tính TỔNG các giá trị trong một cột
--ex: Tính tổng số tiền theo từng nhóm category_id
SELECT
    customer_id,
    SUM (order_amount) oAmount
FROM 
    orders
GROUP BY
    customer_id
ORDER BY
    customer_id ASC
--Dùng MIN, MAX: là để lấy giá trị nhỏ nhất của các giá trị trong một cột.
--ex: Hiển thị sản phẩm có giá thấp nhất theo từng nhóm category_id
SELECT
    category_id,
    MIN (price) 'min_price'
FROM
    products
GROUP BY 
    category_id
ORDER BY
    category_id

SELECT
    category_id,
    MAX (price) 'max_price'
FROM
    products
GROUP BY 
    category_id
ORDER BY
    category_id

-- SUB QUERY : là một câu truy vấn SELECT được nhúng bên trong một câu truy vấn khác
SELECT
    *,
    (SELECT COUNT (product_id) FROM products WHERE products.category_id = categories.category_id)
FROM
    categories 
--viết gọn hơn khi đặt AS 
SELECT
    c.* ,
    (SELECT COUNT (product_id) FROM dbo.products AS p WHERE p.category_id = c.category_id) AS 'number_product'
FROM 
    dbo.categories AS c
--check chéo:
SELECT * FROM dbo.products WHERE category_id = 1
--ex1: tìm tất cả các khách hàng có đơn hàng với tổng giá trị lớn hơn một ngưỡng nào đó
-- và lấy ra danh sách KH đã mua hàng với mức tiền > 10000
SELECT
     * 
FROM 
    customers
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            orders
        GROUP BY
            customer_id
        HAVING 
            SUM (order_amount) > 10000
    )
--ex2: Lấy thông tin đơn hàng của tất cả khách hàng ở New York
SELECT 
    order_id,
    order_date,
    customer_id
FROM 
    orders
WHERE
    customer_id IN (
        SELECT 
            customer_id
        FROM
            customers
        WHERE
            city = 'New York'
    )
ORDER BY
    order_date DESC
--SUB QUERY đi cùng ANY : 1 trong bất kì giá trị nào
SELECT
    product_name,
    price
FROM
    dbo.products
WHERE
    -- Nếu price >= với bất kì giá trị nào thì lấy ra = câu lệnh đúng
    -- trong kết quả SELECT thì WHERE thực thi
    price >= ANY (
        SELECT
            AVG (price) -- AGV : tính giá trị trung bình
        FROM
            dbo.products
        GROUP BY
            brand_id
    )
--SUB QUERY đi cùng ALL: thoả mãn hết khi price lớn hơn ANY thì mới chạy lệnh

--SUB QUERY đi cùng NOTEXITS và EXITS:
--NOT EXISTS phủ định của EXISTS : Lấy thông tin khách hàng, có đơn hàng mua vào năm 2017.
SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM
    dbo.customers c
WHERE
    EXISTS (
        -- Đi tìm những khách hàng mua hàng năm 2017
        SELECT
            customer_id
        FROM
            dbo.orders o
        WHERE
            o.customer_id = c.customer_id
        AND YEAR (order_date) = 2017
    )
ORDER BY
    first_name,
    last_name;

----

--JOIN : là phép kết hợp các hàng từ hai hoặc nhiều bảng dựa trên một điều kiện kết hợp.

--Tạp TABLE về JOIN
--Tạo bảng a
CREATE TABLE basket_a (
    a INT PRIMARY KEY,
    fruit_a VARCHAR (50) NOT NULL
);
--Tạo bảng b
CREATE TABLE basket_b (
    b INT PRIMARY KEY,
    fruit_b VARCHAR (50) NOT NULL
);
--Chèn dữ liệu vào bảng a
INSERT INTO basket_a (a, fruit_a)
VALUES
    (1, 'Apple'),
    (2, 'Orange'),
    (3, 'Banana'),
    (4, 'Cucumber');
--Chèn dữ liệu vào bảng b
INSERT INTO basket_b (b, fruit_b)
VALUES
    (1, 'Orange'),
    (2, 'Apple'),
    (3, 'Watermelon'),
    (4, 'Pear');
SELECT * FROM basket_a
SELECT * FROM basket_b

--INNER JOIN: phép nối được sử dụng kết hợp giữa 2 hoặc nhiều bảng với nhau phải có cùng cột giá trị
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
INNER JOIN  --giao nhau, lấy dữ liệu chung giữa a và b
    basket_b ON fruit_a = fruit_b

--OUTER JOIN: có 3 loại LEFT JOIN, RIGHT JOIN, FULL JOIN
--LEFT JOIN(lấy phần chung bên trái), không khớp trả về NULL
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
LEFT JOIN 
    basket_b ON fruit_a = fruit_b

SELECT
  -- * --nếu muốn lấy gì thì tên đặt .trường (p.product_id , c.price)
    p.product_id,
    p.product_name,
    p.price,
    c.category_name
FROM
   products p
LEFT JOIN 
    categories AS c ON c.category_id = p.category_id
--ex: 
SELECT 
    o.order_id,
    c.first_name,
    o.order_amount,
    o.customer_id,
    c.customer_id cid --đặt một tên khác vì nó hiểu c là customer chứ k phải customerid đang muốn gọi
FROM
    orders o
LEFT JOIN
    customers c ON c.customer_id = o.customer_id
--RIGHT JOIN(lấy phần chung bên phải), không khớp trả về NULL
--FULL JOIN: lấy cả, không có null

--SEFT JOIN: là một phép nối quan hệ với chính nó, có thể hiểu trong mô hình cây quản lý nhân sự: cấp trên <==> cấp dưới
SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    staffs e
LEFT JOIN 
    staffs m ON m.staff_id = e.manager_id
ORDER BY
    manager

--CTEs: cho phép bạn tạo ra một bảng tạm thời mà có thể được sử dụng trong câu truy vấn chính
--ex: Thống kê doanh thu bán ra theo nhân viên trong năm 2018

-- Truy vấn và tạo bảng ảo
WITH cte_sales_amounts (staff, sales, year) AS (
SELECT    
        first_name + ' ' + last_name, 
        SUM(quantity * price * (1 - discount)),
        YEAR(order_date)
    FROM    
        dbo.orders o
    INNER JOIN dbo.order_items i ON i.order_id = o.order_id
    INNER JOIN dbo.staffs s ON s.staff_id = o.staff_id
    GROUP BY 
        first_name + ' ' + last_name,
        year(order_date)
    
)
-- Câu lệnh SELECT này phải thực hiện đồng thời với câu lệnh trên.
SELECT
    staff, 
    sales,
    year
FROM 
    cte_sales_amounts
WHERE
    year = 2018
SELECT * FROM orders
SELECT * FROM order_items

--COMBINING DATA : có 2 toán tử UNION & INTERSECT
--UNION: được sử dụng để kết hợp các kết quả của hai hoặc nhiều câu lệnh SELECT thành một tập kết quả duy nhất. Các bản ghi trong các tập kết quả được hợp nhất không có bất kỳ sự trùng lặp nào.
SELECT 
    first_name, 
    last_name 
FROM 
    customers  
UNION  --có chung SELECT, Loại bỏ giá trị trùng lặp sau khi kết hợp
SELECT
     first_name, 
     last_name 
FROM 
    staffs 
--UNION ALL : không khử trùng
SELECT
    first_name,
    last_name
FROM 
    staffs
UNION ALL -- Giữ giá trị trùng lặp sau khi kết hợp
SELECT
    first_name, 
    last_name
FROM
    customers
--INTERSECT :để lấy các bản ghi chung của 2 hoặc nhiều câu lệnh SELECT. 
--Dùng lấy các danh sách sản phẩm ĐÃ ĐƯỢC bán ra
SELECT
    product_id
FROM
    products
INTERSECT -- SELECT phải cùng số lượng cột và kiểu dữ liệu tương ứng.
SELECT
    product_id
FROM
    order_items
--EXCEPT: Dùng để lấy các bản ghi của câu lệnh SELECT đầu tiên mà không có trong các câu lệnh SELECT sau
--Lấy ra danh sách những sản phẩm CHƯA được bán ra.
SELECT
    product_id
FROM
    products
EXCEPT --SELECT phải cùng số lượng cột và kiểu dữ liệu tương ứng.
SELECT
    product_id
FROM
    order_items --nếu ở đây chưa có tức là chưa được bán ra