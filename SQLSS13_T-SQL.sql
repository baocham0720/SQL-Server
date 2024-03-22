-- Khai báo biến chưa gán giá trị
DECLARE @model_year SMALLINT --kiểu dữ liệu của biến phải trùng với kiểu dữ liệu của trường trong cột đó
--DECLARE @model_year SMALLINT = 2016 : khai báo biến có giá trị trực tiếp

--Gán giá trị cho biến
SET @model_year = 2018

--Truy cập đến giá trị của biến
SELECT @model_year --chạy hết câu lệnh cùng 1 lúc

--Debug giá trị của biến
PRINT @model_year

--ex: Lấy ra sản phẩm có model_year = 2016
SELECT
    *
FROM 
    products 
WHERE 
    model_year = @model_year 

--Khai báo biến bằng kết quả của một câu lệnh truy vấn
DECLARE @product_count INT
SET @product_count = (
    SELECT
        COUNT (product_id) 
    FROM 
        products
    )
SELECT @product_count

--Synonyms: một đối tượng CSDL được sử dụng để tạo ra một tên định danh thay thế cho một đối tượng khác trong cùng CSDL hoặc CSDL khác.
--Dùng Sym đặt tên 1 lần rồi sử dụng luôn sau đó, không trùng nhau và không trùng table hệ thống
CREATE SYNONYM tp
FOR products 

--BEGIN END : Khai báo một khối lệnh. Khối lệnh là tập hộp các câu lệnh SQL thực hiện cùng với nhau có thể lồng các khối lệnh vào nhau
BEGIN
SELECT * FROM tp
SELECT * FROM categories
END
--ex: 
BEGIN
    SELECT
        product_id,
        product_name
    FROM
        dbo.products
    WHERE
        price > 10000;

    IF @@ROWCOUNT = 0 -- biến này là biến hệ thống và trả kết quả gần nhất
        -- Nếu không trả về thì in giá trị ra cửa sổ message
        PRINT 'No product with price greater than 100000 found'; --debug
END

--IF ELSE : 
DECLARE @a INT = 4
IF 
    @a > 3
BEGIN
    PRINT 'yes'
END 
ELSE
BEGIN
    PRINT 'No'
END
-- Ex: 
BEGIN
    DECLARE @sales INT;

    SELECT 
        @sales = SUM(price * quantity)
    FROM
        dbo.order_items AS i
        INNER JOIN dbo.orders o ON o.order_id = i.order_id
    WHERE
        YEAR(order_date) = 2018;

    SELECT @sales;

    IF @sales > 1000000
    BEGIN
        PRINT 'Great! The sales amount in 2018 is greater than 1,000,000';
    END
    ELSE
    BEGIN
        PRINT 'Sales amount in 2018 did not reach 1,000,000';
    END
END
--Khai báo 2 biến cùng lúc hoặc nhièu biến bằng ,
BEGIN
    DECLARE @x INT = 10,
            @y INT = 20

    IF (@x > 0)
    BEGIN
        IF (@x < @y)
            PRINT 'x > 0 and x < y'
        ELSE
            PRINT 'x > 0 and x >= y'
    END			
END

--WHILE : 
DECLARE @counter INT = 1
WHILE
    @counter <= 5 --luôn luôn là phép toán <= để xác định điểm dừng vòng lặp
BEGIN
    PRINT @counter
    SET @counter = @counter + 1
END

--BREAK : được sử dụng để kết thúc một khối lệnh hoặc vòng lặp
DECLARE @c INT = 0
WHILE @c <= 5
BEGIN
    SET @c = @c + 1
    IF @c = 4
        BREAK -- Bỏ qua những câu lệnh phía sau nó (nếu c = 4 thì bỏ qua và thoát khỏi vòng lặp)
    PRINT @c
END

--CONTINUE: được sử dụng để bỏ qua phần còn lại của vòng lặp hiện tại và chuyển đến lần lặp tiếp theo
DECLARE @cou INT = 0
WHILE @cou < 5
BEGIN
    SET @cou = @cou + 1
    IF @cou = 3
        CONTINUE --Tiếp tục vòng lặp, bỏ qua câu lệnh sau nó
    PRINT @cou
END

--GOTO :được sử dụng để chuyển quyền điều khiển đến một điểm nhãn (label) cụ thể trong mã SQL
DECLARE @i INT = 1
WHILE 
    @i <= 10 
BEGIN
    IF @i = 5 
    BEGIN
        GOTO label --thoát khỏi vòng lặp, nhảy đến vị trí label
    END
    PRINT @i
    SET @i = @i + 1
END --hết vòng lặp WHILE 
label: --nằm ngoài vòng lặp WHILE
PRINT 'Done' --nằm ngoài vòng lặp WHILE

--RETURN : hàm (học sau)

--WAITFOR: sử dụng để tạm dừng thực thi một khối lệnh hoặc truy vấn trong một khoảng thời gian nhất định
PRINT 'Start'
WAITFOR DELAY '00:00:05' -- Dừng 5s rồi chạy lệnh sau đó
PRINT 'End'

--T-SQL FUNCTION: cho phép tự định nghĩa ra hàm và có những hàm sẵn
--Scalar-valued Functions: nó nhận đầu vào và trả về một giá trị duy nhất.
-- Dùng từ khóa CREATE FUNCTION
-- udsf_ : hàm tự định nghĩa nối với tên muốn đặt
CREATE FUNCTION udsf_GetFullName (
    @FirstName nvarchar(50), 
    @LastName nvarchar(50)
) --điền tham số trong ()
RETURNS nvarchar(100) --returns về kiểu dữ liệu trả về là gì 
AS
BEGIN
    DECLARE @FullName nvarchar(100)
    SET @FullName = @FirstName + ' ' + @LastName
    RETURN @FullName 
END
--khi sử dụng hàm để rút gọn lệnh khi gọi hàm
SELECT
    customer_id,
    --first_name + ' ' + last_name fullname
    dbo.udsf_GetFullName (first_name, last_name) as fullname
FROM customers

--ex: Viết 1 function trả về thành tiền sản phẩm
CREATE FUNCTION udsf_GetAmountProduct(
    @Price money,
    @Discount decimal(18, 2),
    @Quantity decimal(18, 2)
    )
RETURNS decimal(18, 2)
AS
BEGIN
    RETURN (@Price * (100 - @Discount) / 100) * @Quantity
END
--Sử dụng :
SELECT
    order_id,
    product_id,
    dbo.udsf_GetAmountProduct (price, discount, quantity) total_amount
FROM 
    order_items
--ex: tính tổng tiền sản phẩm số :
SELECT 
    order_id,
    SUM (dbo.udsf_GetAmountProduct (price, discount, quantity)) as Total
FROM
    order_items
GROUP BY
    order_id
ORDER BY
    order_id
--Dùng ALTER FUNCTION : để sửa
--DÙNG DROP FUNCTION : để xoá 

--Table-valued Functions: nó nhận đầu vào và trả về một bảng (table)
--ex: Viết một Table-valued Functions trả về danh sách các sản phẩm có giảm giá (discount > 0)
CREATE FUNCTION udtf_ProductInfo ()
RETURNS TABLE 
AS
RETURN (
SELECT 
    p.*,
    c.category_name
FROM 
    products p
LEFT JOIN 
    categories c ON c.category_id = p.category_id
)
--thay hàm cho một table và được định nghĩa
SELECT 
    *
FROM
    dbo.udtf_ProductInfo ()

--WINDOWN FUNCTION : một tập hợp các hàm tích hợp sẵn cho phép bạn thực hiện các tính toán trên một tập hợp các hàng trong một kết quả truy vấn, dựa trên một cửa sổ hoặc phạm vi xác định.

--Expressions *
--Mệnh đề CASE : 
--simple CASE expression :
SELECT
    order_id,
    --order_status --thay vì dùng order_status hiện thị số thì thay bằng hiện thị chữ là dùng CASE
    CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'completed'
    END AS order_status
FROM
    orders
--searched CASE expression :
SELECT    
    o.order_id, 
    SUM(quantity * price) order_value,
    CASE
        WHEN SUM(quantity * price) <= 500 
            THEN 'Very Low' --đơn hàng giá trị rất thấp
        WHEN SUM(quantity * price) > 500 AND 
            SUM(quantity * price) <= 1000 
            THEN 'Low' --đơn hàng giá trị thấp
        WHEN SUM(quantity * price) > 1000 AND 
            SUM(quantity * price) <= 5000 
            THEN 'Medium' --đơn hàng giá trị trung bình
        WHEN SUM(quantity * price) > 5000 AND 
            SUM(quantity * price) <= 10000 
            THEN 'High' --đơn hàng giá trị ca0
        WHEN SUM(quantity * price) > 10000 
            THEN 'Very High' --đơn hàng giá trị rất cao
    END order_priority
FROM    
    dbo.orders o
INNER JOIN sales.order_items i ON i.order_id = o.order_id
WHERE 
    YEAR(order_date) = 2018
GROUP BY 
    o.order_id

--COALESCE : là một hàm dùng để trả về giá trị đầu tiên không null từ danh sách các biểu thức
SELECT 
    COALESCE(NULL, 'Hi', 'Hello', NULL) result;
--Kết quả: Hi
--ex:
SELECT * FROM stores
UPDATE stores SET phone = NULL WHERE store_id = 3
SELECT 
    store_id, 
    store_name, 
    COALESCE(phone,'N/A') phone, --Trường phone nếu NULL thì trả về 'N/A', còn không thì lấy chính nó
    email
FROM 
    stores
ORDER BY 
    store_name, 
    store_id 

--NULLIF là một hàm được sử dụng để so sánh hai biểu thức. Nếu hai biểu thức bằng nhau, NULLIF sẽ trả về giá trị null. 
--Nếu hai biểu thức không bằng nhau, NULLIF sẽ trả về giá trị của biểu thức đầu tiên.
SELECT NULLIF(10, 10) result; --=> NULL
SELECT NULLIF(20, 10) result; --=> 20
SELECT NULLIF('Hello', 'Hi') result; --=> 'Hello'