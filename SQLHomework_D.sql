--Homework D:
--1.Hiển thị tất cả các sản phẩm cùng với tên danh mục (category_name)
SELECT
    p.*,
    c.category_name
FROM
    products p
INNER JOIN 
    categories c ON p.category_id = c.category_id
--2.Hiển thị tất cả các sản phẩm cùng với tên thương hiệu (brand_name).
SELECT
    p.*,
    b.brand_name
FROM
    products p
INNER JOIN 
    brands b ON p.brand_id = b.brand_id
--3.Hiển thị tất cả các sản phẩm cùng với thông tin chi tiết của categories và brands
SELECT
    p.*,
    c.category_name,
    b.brand_name
FROM
    products p
INNER JOIN 
    categories c ON p.category_id = c.category_id
INNER JOIN 
    brands b ON p.brand_id = b.brand_id
--4.Hiển thị tất cả các sản phẩm có số lượng tồn kho <= 5
SELECT
    p.*,
    s.quantity,
    s.store_id
FROM
    products p
LEFT JOIN
    stocks s ON s.product_id = p.product_id
SELECT * FROM stocks WHERE product_id = 1 AND store_id= 1
--5.Hiển thị tất cả các đơn hàng cùng với thông tin chi tiết khách hàng Customer.
SELECT
    o.*,
    c.first_name,
    c.last_name,
    c.email,
    c.phone
FROM
    orders o
INNER JOIN 
    customers c ON c.customer_id = o.customer_id
--6.Hiển thị tất cả các đơn hàng cùng với thông tin chi tiết nhân viên Staff.
SELECT 
    o.*,
    s.first_name,
    s.last_name,
    s.email,
    s.phone
FROM
    orders o
INNER JOIN
    staffs s ON s.staff_id = o.staff_id
    SELECT * FROM staffs
--7.Hiển thị tất cả các đơn hàng cùng với thông tin chi tiết khách hàng Customer và nhân viên Staff.
SELECT
    o.*,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    s.first_name,
    s.last_name,
    s.email,
    s.phone
FROM
    orders o
INNER JOIN 
    customers c ON c.customer_id = o.customer_id
INNER JOIN
    staffs s ON s.staff_id = o.staff_id
--8.Hiển thị tất cả danh mục (Categories) với số lượng hàng hóa trong mỗi danh mục. (Dùng INNER JOIN + GROUP BY với lệnh COUNT và Dùng SubQuery với lệnh COUNT)
SELECT
	c.category_id,
	c.category_name,
	c.description,
	COUNT(p.product_id)  count_product
FROM
	dbo.categories  c
INNER JOIN
	dbo.products  p ON p.category_id = c.category_id
GROUP BY
	c.category_id,
	c.category_name,
	c.description
--C2.Dùng SubQuery với lệnh COUNT
SELECT
	c.category_id,
	c.category_name,
	c.description,
	(SELECT COUNT(*) FROM dbo.products as p WHERE c.category_id = p.category_id) AS count_product
FROM
	dbo.categories c
--9.Hiển thị tất cả thương hiệu (brands) với số lượng hàng hóa mỗi thương hiệu (brands). (Dùng INNER JOIN + GROUP BY với lệnh COUNT và Dùng SubQuery với lệnh COUNT)
SELECT
    b.brand_id,
    b.brand_name,
    b.description,
    COUNT(p.product_id) count_product
FROM   
    brands b
INNER JOIN
	products p ON p.brand_id = p.brand_id
GROUP BY
    b.brand_id,
    b.brand_name,
    b.description
--C2.Dùng SubQuery với lệnh COUNT
SELECT
	b.brand_id,
	b.brand_name,
	b.description,
	(SELECT COUNT(*) FROM products p WHERE b.brand_id = p.brand_id) AS count_product
FROM
	 brands b
--10.Hiển thị tất cả các sản phẩm được bán trong khoảng từ ngày, đến ngày
SELECT
	oi.product_id,
	p.product_name,
	o.order_date
FROM
	dbo.order_items AS oi
INNER JOIN
	dbo.orders AS o ON o.order_id = oi.order_id
INNER JOIN
	dbo.products AS p ON p.product_id = oi.product_id
WHERE o.order_date >= '2017-01-01' AND o.order_date <= '2017-12-30'
ORDER BY
	p.product_id ASC
--11.Hiển thị tất cả các khách hàng mua hàng trong khoảng từ ngày, đến ngày
SELECT
	o.customer_id,
	c.first_name,
	c.last_name,
	o.order_date
FROM
	dbo.orders AS o
INNER JOIN
	dbo.customers AS c ON c.customer_id = o.customer_id		
WHERE o.order_date >= '2017-01-01' AND o.order_date <= '2017-12-30'
--12.Hiển thị tất cả các khách hàng mua hàng (với tổng số tiền) trong khoảng từ ngày, đến ngày . (Dùng INNER JOIN + GROUP BY với lệnh SUM và Dùng SubQuery với lệnh SUM )
SELECT
	o.customer_id,
	c.first_name,
	c.last_name,
	o.order_date,
	SUM((oi.price * (100 - oi.discount) / 100) * oi.quantity) AS total_amount
FROM
	dbo.orders AS o
INNER JOIN
	dbo.customers AS c ON c.customer_id = o.customer_id	
INNER JOIN 
	dbo.order_items AS oi ON oi.order_id = o.order_id
WHERE o.order_date >= '2017-01-01' AND o.order_date <= '2017-12-30'
GROUP BY
	o.customer_id,
	c.first_name,
	c.last_name,
	o.order_date
--13.Hiển thị tất cả đơn hàng với tổng số tiền của đơn hàng đó
SELECT
	o.order_id,
	SUM((oi.price * (100 - oi.discount) / 100) * oi.quantity) AS total_amount
FROM
	dbo.orders AS o
INNER JOIN
	dbo.order_items AS oi ON oi.order_id = o.order_id
GROUP BY
	o.order_id
ORDER BY
	o.order_id
--14.Hiển thị tất cả các nhân viên bán hàng với tổng số tiền bán được
--15.Hiển thị tất cả các sản phẩm không bán được
/*
Tất cả sản phẩm thì liên quan đến products
bán được hay không bán được thì liên quan đến order_items
*/
SELECT 
	p.*,
	oi.order_id
FROM
	dbo.products AS p
LEFT JOIN
	dbo.order_items AS oi ON oi.product_id = p.product_id
/*
Khi bạn chạy câu lệnh trên bạn sẽ thấy cột order_id có chứa những giá
trị NULL. Lí do nó phản ảnh đúng lý thuyết của LEFT JOIN (Canh bên trái là products. Phải ko khớp thì là NULL)
==> Những sản phẩm mà có cột order_id = NULL là những sản phẩm ko bán được
==> WHERE lại
*/
SELECT 
	p.*,
	oi.order_id
FROM
	dbo.products AS p
LEFT JOIN
	dbo.order_items AS oi ON oi.product_id = p.product_id
WHERE 
	oi.order_id IS NULL
---==> Đây là những sản phẩm không bán được.
---==> Ngược lại cho những sản phẩm bán được.
--16.Hiển thị tất cả các thương hiệu (brands) không bán được trong khoảng từ ngày, đến ngày
--17.Hiển thị top 3 các nhân viên bán hàng với tổng số tiền bán được từ cao đến thấp trong khoảng từ ngày, đến ngày
--18.Hiển thị top 5 các khách hàng mua hàng với tổng số tiền mua được từ cao đến thấp trong khoảng từ ngày, đến ngày
--19.Hiển thị danh sách các mức giảm giá (discount) của cửa hàng
--20.Hiển thị tất cả danh mục (Categories) với tổng số tiền bán được trong mỗi danh mục. (Dùng INNER JOIN + GROUP BY với lệnh SUM và Dùng SubQuery với lệnh SUM)
--21.Hiển thị tất cả đơn hàng với tổng số tiền mà đã được giao hàng thành công trong khoảng từ ngày, đến ngày
--22.Hiển thị tất cả đơn hàng có tổng số tiền bán hàng nhiều nhất trong khoảng từ ngày, đến ngày
--23.Hiển thị tất cả đơn hàng có tổng số tiền bán hàng ít nhất trong khoảng từ ngày, đến ngày
--24.Hiển thị trung bình cộng giá trị các đơn hàng trong khoảng từ ngày, đến ngày
--25.Hiển thị các đơn hàng có giá trị cao nhất
--26.Hiển thị các đơn hàng có giá trị thấp nhất