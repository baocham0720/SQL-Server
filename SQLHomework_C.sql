--Homework C:
--1.Hiển thị tất cả các sản phẩm có giảm giá (discount) <= 3%
SELECT 
    *
FROM
    products
WHERE 
    DISCOUNT <= 3
--2.Hiện thị tất cả các sản phẩm không có giảm giá (discount)
SELECT 
    *
FROM
    products
WHERE
    DISCOUNT <= 0
--3.Hiển thị tất cả các sản phẩm có Giá bán sau khi đã giảm giá (discount) <= 100
SELECT 
    *
FROM
    products
WHERE 
    (price - (price * discount )/100) <= 100
--4.Hiện thị tất cả các sản phẩm thuộc danh mục có category_id = 4 và thương hiệu = 9
SELECT 
    *
FROM 
    products
WHERE 
    category_id = 4 AND brand_id = 9
--5.Hiện thị tất cả các sản phẩm thuộc danh mục có category_id = 2 và 4.
SELECT 
    *
FROM 
    products
WHERE 
    category_id IN (2, 4)
--6.Hiện thị tất cả các sản phẩm có model sản xuất (model_year) từ 2017 - 2020.
SELECT
    *
FROM
    products
WHERE
    model_year >= 2017
    AND model_year <=2020
--7.Hiển thị tất cả các khách hàng có địa chỉ ở city = 'New York'
SELECT
    *
FROM
    customers
WHERE
    city = 'New York'
--8.Hiển thị tất cả các khách hàng có địa chỉ ở city = 'New York' hoặc city = 'Victoria'
SELECT
    *
FROM
    customers
WHERE
    city = 'New York' OR city = 'Victoria'
--9.Hiển thị tất cả các khách hàng có năm sinh 1990
SELECT
    *
FROM
    customers
WHERE
    birthday LIKE '1990%'
--10.Hiển thị tất cả các khách hàng có tuổi trên 40.
SELECT 
    *
FROM 
    customers
WHERE  
    YEAR(GETDATE()) - YEAR(birthday) > 40

--11.Hiển thị tất cả các khách hàng có tuổi từ 20 đến 30.
SELECT 
    *
FROM 
    customers
WHERE 
    YEAR(GETDATE()) - YEAR(birthday) >= 20 
    AND YEAR(GETDATE()) - YEAR(birthday) <= 30

--12.Hiển thị tất cả các khách hàng có số đuôi điện thoại '500'
SELECT
    *
FROM
    customers
WHERE
    phone LIKE '%500'
--13.Hiển thị tất cả các khách hàng có tên chứa ký tự de.
SELECT
    *
FROM
    customers
WHERE
    first_name LIKE '%de%'
--14.Hiển thị tất cả các khách hàng có sinh nhật là hôm nay. Gợi ý: dùng hàm GETDATE(), MONTH(), DAY()
SELECT
    *
FROM
    customers
WHERE 
    MONTH(birthday) = MONTH(GETDATE()) 
    AND DAY(birthday) = DAY(GETDATE())
--15.Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED (order_status = 4)
SELECT 
    *
FROM
    orders
WHERE
    order_status = 4
--16.Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED (order_status = 4) trong ngày hôm nay
SELECT 
    *
FROM 
    orders
WHERE
     order_status = 4 
     AND DAY(order_date) = DAY(GETDATE())
--17.Hiển thị tất cả các đơn hàng chưa hoàn thành trong tháng này
SELECT 
    *
FROM 
    orders
WHERE
     order_status != 4 -- ! phủ định hoàn thành
     AND MONTH(order_date) = MONTH(GETDATE())
--18.Hiển thị tất cả các đơn hàng có trạng thái là CANCELED (order_status = 3)
 SELECT 
    *
FROM 
    orders
WHERE
    order_status = 3
--19.Hiển thị tất cả các đơn hàng có trạng thái là CANCELED (order_status = 3) trong ngày hôm nay
SELECT 
    *
FROM 
    orders
WHERE
     order_status = 3 
     AND DAY(order_date) = DAY(GETDATE())
--20.Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED (order_status = 4) trong tháng này
SELECT 
    *
FROM 
    orders
WHERE
     order_status = 4 
     AND MONTH(order_date) = MONTH(GETDATE())
--21.Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED (order_status = 4) trong tháng 1 năm 2016
SELECT 
    *
FROM 
    orders
WHERE
    order_status = 4 
    AND MONTH(order_date) = 1 AND YEAR(order_date) = 2016
--22.Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED (order_status = 4) trong năm 2016
SELECT 
    *
FROM 
    orders
WHERE
    order_status = 4 
    AND YEAR(order_date) = 2016
--23.Hiển thị tất cả các đơn hàng có hình thức thanh toán là CASH (payment_type = 4)
SELECT 
    *
FROM 
    orders
WHERE
    payment_type = 4
--24.Hiển thị tất cả các đơn hàng có hình thức thanh toán là CREADIT CARD (payment_type = 2)
SELECT 
    *
FROM 
    orders
WHERE
    payment_type = 2
--25.Hiển thị tất cả các đơn hàng có địa chỉ giao hàng ở thành phố Houston
SELECT 
    *
FROM 
    orders
WHERE
    shipping_city = 'Houston'
--26.Hiển thị tất cả các nhân viên có sinh nhật là tháng này
--27.Hiển thị tất cả các thương hiệu (brands) có tên là: (Electra, Haro, Heller, Trek)
SELECT 
    *
FROM 
    brands
WHERE
    brand_name IN ('Electra' , 'Haro' , 'Heller' , 'Trek')
--28.Hiển thị tất cả các thương hiệu (brands) không có tên là: (Heller, Trek)
SELECT 
    *
FROM 
    brands
WHERE
    brand_name NOT IN ('Heller' , 'Trek') 
--29.Hiển thị tất cả các khách hàng có sinh nhật là ngày hôm nay
SELECT 
    *
FROM 
    customers
WHERE 
    MONTH(birthday) = MONTH(GETDATE())
    AND DAY(birthday) = DAY(GETDATE())
--30.Hiển thị xem có bao nhiêu mức giảm giá (discount) khác nhau.
SELECT 
    discount
FROM
    products
GROUP BY 
    discount
--31.Hiển thị xem có bao nhiêu mức giảm giá (discount) khác nhau và số lượng sản phẩm có mức giảm giá (discount) đó.
SELECT
	discount,
	COUNT(product_id) as count_product
FROM
	dbo.products
GROUP BY
	discount
--32.Hiển thị xem có bao nhiêu mức giảm giá (discount) khác nhau và số lượng sản phẩm có mức giảm giá (discount) đó, sắp xếp theo số lượng giảm giá (discount) giảm dần.
SELECT
    discount,
    COUNT (product_id) count_p
FROM
    products
GROUP BY
    discount
ORDER BY 
    COUNT (product_id) DESC
--33.Hiển thị xem có bao nhiêu mức giảm giá (discount) khác nhau và số lượng sản phẩm có mức giảm giá (discount) đó, sắp xếp theo số lượng giảm giá (discount) tăng dần, chỉ hiển thị các mức giảm giá (discount) có số lượng sản phẩm >= 5
SELECT 
    discount,
    COUNT (product_id) count_product
FROM
    products
GROUP BY
    discount
HAVING
    discount >= 5
ORDER BY
    COUNT (product_id) ASC
--34.Hiển thị xem có bao nhiêu mức tuổi khác nhau của khách hàng và số lượng khách hàng có mức tuổi đó, sắp xếp theo số lượng khách hàng tăng dần.
SELECT 
	DATEDIFF(year, birthday, GETDATE()) as age,
	count(customer_id) as count_customer
FROM
	dbo.customers
GROUP BY
	DATEDIFF(year, birthday, GETDATE())
ORDER BY
	count(customer_id) ASC
--35.Hiển thị xem có bao nhiêu mức tuổi khác nhau của khách hàng và số lượng khách hàng có mức tuổi đó, sắp xếp theo số lượng khách hàng giảm dần.
SELECT 
	DATEDIFF(year, birthday, GETDATE()) as age,
	count(customer_id) as count_customer
FROM
	dbo.customers
GROUP BY
	DATEDIFF(year, birthday, GETDATE())
ORDER BY
	count(customer_id) DESC
--36.Hiển thị số lượng đơn hàng theo từng ngày khác nhau sắp xếp theo số lượng đơn hàng giảm dần.
SELECT  
    order_date,
    COUNT (order_id) count_order
FROM
    orders
GROUP BY
    order_date
ORDER BY
    count_order DESC
--37.Hiển thị số lượng đơn hàng theo từng tháng khác nhau sắp xếp theo số lượng đơn hàng giảm dần.
SELECT 
    MONTH(order_date)  month,
    COUNT(order_id)  count_order
FROM 
    orders
GROUP BY 
    MONTH (order_date)
ORDER BY 
    count_order DESC
--38.Hiển thị số lượng đơn hàng theo từng năm khác nhau sắp xếp theo số lượng đơn hàng giảm dần.
SELECT 
    YEAR(order_date) year,
    COUNT(order_id)  count_order
FROM 
    orders
GROUP BY 
    YEAR (order_date)
ORDER BY 
    count_order DESC
--39.Hiển thị số lượng đơn hàng theo từng năm khác nhau sắp xếp theo số lượng đơn hàng giảm dần, chỉ hiển thị các năm có số lượng đơn hàng >= 5.
SELECT 
    YEAR(order_date) year,
    COUNT(order_id) count_order
FROM 
    orders
GROUP BY 
    YEAR (order_date)
HAVING
    COUNT(order_id) >= 5
ORDER BY 
    count_order DESC

