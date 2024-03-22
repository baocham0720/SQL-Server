--VIEW : là một table ảo tạo ra từ một hoặc nhiều bảng hoặc các view khác
-- Tạo VIEW :
--ex: Câu lệnh bên dưới trả về doanh số bán ra của mỗi sản phẩm theo ngày
CREATE VIEW dbo.v_getSalebyDate
AS
SELECT 
    year (order_date) y,
    month (order_date) m,
    day (order_date) d, 
    p.product_id,
    product_name,
    quantity * i.price sales 
FROM   
    orders o
INNER JOIN order_items i ON i.order_id = o.order_id
INNER JOIN products p ON p.product_id = i.product_id

SELECT
    * 
FROM 
    dbo.v_getSalebyDate -- Debug xem trong bảng có gì
INSERT 
    dbo.v_getSalebyDate
    (y,m,d, product_id, product_name,sales)
VALUES
(2019, 1,1,182, 'Trek Domane SL 5 Disc - 2018', 2499.99)

--Liệt kê danh sách View :
SELECT * FROM sys.views 
SELECT * FROM sys.tables

--Xoá view :
DROP VIEW IF EXISTS dbo.v_getSalebyDate

--With SCHEMABINDING: view sẽ được ràng buộc với các đối tượng khác trong cơ sở dữ liệu. Nếu bạn thực hiện thay đổi cấu trúc của các đối tượng được ràng buộc (như thay đổi tên cột, tên bảng, ...), bạn sẽ không thể thực hiện được.
CREATE VIEW dbo.v_daily_sales
WITH SCHEMABINDING  -- ràng buộc cấu trúc với các table tham chiếu
AS
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    p.product_name,
    p.discount,
    (i.quantity * i.price) AS sales
FROM
    dbo.orders AS o
INNER JOIN dbo.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN dbo.products AS p
    ON p.product_id = i.product_id

--WITH ENCRYPTION : mã nguồn của đối tượng sẽ được mã hóa và không thể đọc hoặc truy cập trực tiếp thông qua các công cụ SQL
CREATE VIEW dbo.v_Dailysales
WITH ENCRYPTION -- Mã hóa, ko cho xem cấu trúc của VIEW
AS
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    p.product_name,
    p.discount,
    (i.quantity * i.price) AS sales
FROM
    dbo.orders AS o
INNER JOIN dbo.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN dbo.products AS p
    ON p.product_id = i.product_id

--WITH CHECK OPTION : là một cấu hình được sử dụng trong câu lệnh CREATE VIEW để đảm bảo rằng các dòng dự liệu được chọn trong View cũng phải thỏa mãn điều kiện của View. Nếu bạn thêm hoặc cập nhật dữ liệu thông qua View, nó chỉ cho phép các thay đổi đáp ứng điều kiện của View.
CREATE VIEW dbo.v_dailysale
AS
SELECT
    p.product_id,
    p.product_name,
    p.discount,
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    (i.quantity * i.price) AS sales
FROM
    dbo.orders AS o
INNER JOIN dbo.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN dbo.products AS p
    ON p.product_id = i.product_id
WHERE p.discount > 0.05 -- Nếu không thõa mãn WHERE thì VIEW sẽ không chạy được
WITH CHECK OPTION

SELECT * FROM products WHERE product_id = 8
SELECT * FROM dbo.v_dailysale
UPDATE dbo.v_dailysale
SET discount = 0.04 WHERE product_id = 8

--Xem cấu trúc View
EXEC sp_helptext [dbo.v_dailysale]
--OR
EXEC sp_helptext 'dbo.v_dailysale'

--STORED PROCEDURES: là một khối mã SQL có thể được lưu trữ trong cơ sở dữ liệu. Một Stored Procedure là một tập hợp các câu lệnh SQL được đặt tên và gán một cách lưu trữ trong hệ thống quản lý cơ sở dữ liệu.
--Được sử dụng để thực hiện các tác vụ hoặc thao tác dữ liệu phức tạp trong cơ sở dữ liệu. Chúng có thể chứa các câu lệnh SELECT, INSERT, UPDATE, DELETE, và các câu lệnh điều khiển như IF, WHILE, và các cấu trúc điều khiển khác. Một Stored Procedure có thể nhận đầu vào (tham số) và trả về giá trị đầu ra (kết quả).
--Tạo STORE :
--ex: lấy danh sách sản phẩm
CREATE PROCEDURE usp_ProductList --usp: tiếp đầu ngữ
AS
BEGIN
   BEGIN TRY
        SELECT 
            product_name, 
            price
        FROM 
            dbo.products
        ORDER BY 
            product_name;
    END TRY
    BEGIN CATCH
        -- Nếu có lỗi xảy ra, hiển thị thông tin lỗi
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
        THROW --Ném lỗi
    END CATCH
END
--Sử dụng STORE:
EXECUTE usp_ProductList --thực thi toàn bộ khối lệnh bên trong

--PROC có tham số đầu vào như FUNCTION:
--ex: Lấy danh sách sản phẩm có model_year > 2018
CREATE PROCEDURE usp_FindProductsByModelYear(@model_year INT)
AS
BEGIN
    BEGIN TRY
        SELECT
            product_name,
            price
        FROM 
            dbo.products
        WHERE
            model_year >= @model_year
        ORDER BY
            price;
    END TRY
    BEGIN CATCH
        -- Nếu có lỗi xảy ra, hiển thị thông tin lỗi
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
        THROW --Ném lỗi
    END CATCH
END
--Sử dụng Store khi có tham số :
EXEC uspFindProductsByModelYear 2018

-- Tạo Store có tham số OUTPUT : tham số đầu ra
--ex: Lấy danh sách đơn hàng bán ra từ ngày đến ngày.
CREATE PROCEDURE usp_TotalOrderByRangeDate (
    @FromDate DATETIME, --tham số đầu vào
    @ToDate DATETIME, --tham số đầu vào
    @Total INT OUTPUT --Tham số đầu ra OUTPUT
)
AS
BEGIN
  SELECT @Total = COUNT(*) FROM orders WHERE CAST(order_date AS DATE)  BETWEEN @FromDate AND @ToDate
END;
--sử dụng : thực hiện 3 lệnh cùng 1 lúc
DECLARE @TotalOrders INT;

EXEC usp_TotalOrderByRangeDate '2018-01-01', '2018-12-31', @TotalOrders OUTPUT;

SELECT @TotalOrders as TotalOrders;

--Các tùy chọn khi tạo stored procedure
--WITH ENCRYPTION: mã nguồn của đối tượng sẽ được mã hóa và không thể đọc hoặc truy cập trực tiếp thông qua các công cụ SQL
CREATE PROCEDURE usp_GetOrders
WITH ENCRYPTION
  @FromDate DATETIME,
  @ToDate DATETIME
AS
BEGIN
  SELECT o.*, od.product_id, od.quantity, od.price, od.discount
  FROM orders AS o
    INNER JOIN order_items AS od ON o.order_id = od.order_id
  WHERE o.order_date BETWEEN @FromDate AND @ToDate
END

--WITH RECOMPILE :sẽ được biên dịch lại mỗi khi thực thi. Điều này sẽ giúp tăng hiệu suất thực thi của stored procedure.
CREATE PROCEDURE usp_GetOrders
WITH RECOMPILE
  @FromDate DATETIME,
  @ToDate DATETIME
AS
BEGIN
  SELECT o.*, od.product_id, od.quantity, od.price, od.discount
  FROM orders AS o
    INNER JOIN order_items AS od ON o.order_id = od.order_id
  WHERE o.order_date BETWEEN @FromDate AND @ToDate
END

--WITH EXECUTE AS : sẽ được thực thi với quyền của người dùng được chỉ định.
CREATE PROCEDURE usp_GetOrders
WITH EXECUTE AS 'dbo'
  @FromDate DATETIME,
  @ToDate DATETIME
AS
BEGIN
  SELECT o.*, od.product_id, od.quantity, od.price, od.discount
  FROM orders AS o
    INNER JOIN order_items AS od ON o.order_id = od.order_id
  WHERE o.order_date BETWEEN @FromDate AND @ToDate
END

-- Stored procedure Có RETURN:
CREATE PROCEDURE CheckOrderStatus
    @OrderId INT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM Orders WHERE OrderId = @OrderId)
        RETURN 1 -- Order exists
    ELSE
        RETURN 0 -- Order does not exist
END;

--sử dụng:
DECLARE @Status INT
EXEC @Status = CheckOrderStatus 12345
SELECT @Status as Status
--Trong đó, 12345 là ID của đơn hàng bạn muốn kiểm tra. Giá trị trả về sẽ được lưu trong biến @Status.

--Querying Metadata : 
--là quá trình truy vấn thông tin về cấu trúc và thông tin liên quan đến cơ sở dữ liệu, bảng, cột, view, Stored Procedure và các đối tượng khác trong hệ thống quản lý cơ sở dữ liệu.
--Truy vấn thông tin về bảng và cột:
SELECT *
FROM sys.tables
WHERE name = 'Tên_Bảng' --tên view hoặc tên store procedures

SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID('Tên_Bảng')

