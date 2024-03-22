--Verbose Truncation Warnings:  có thể được hiểu là một cách thức hoạt động hoặc một tính năng trong việc cắt giảm (truncation) thông báo dài hay chi tiết (verbose warnings) trong lập trình hoặc các ngôn ngữ lập trình.
CREATE TABLE [dbo].[tbl_Color](
    [Color ID] [int] IDENTITY(1,1) NOT NULL,
    [Color Name] [varchar](3) NULL
) ON [PRIMARY]
GO
 
INSERT INTO [dbo].[tbl_Color]
           ([Color Name])
     VALUES
           ('Red'),
           ('Blue'), -- Vượt quá độ dài đã khai báo
           ('Green') --
GO

--Vulnerability Assessment (đánh giá lỗ hổng) là quá trình xác định, đánh giá và đo lường các lỗ hổng bảo mật trong hệ thống, mạng, ứng dụng hoặc công nghệ thông tin

--JSON Data :
--FOR JSON PATH: Dùng để chuyển kết quả của một câu lệnh SELECT thành một đối tượng JSON
SELECT
    O.*,
    (SELECT * FROM customers AS C WHERE O.customer_id = C.customer_id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS customer,
    (SELECT * FROM staffs AS S WHERE O.staff_id = S.staff_id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS staffs
FROM 
    orders AS O

--Hàm JSON_VALUE: Dùng để trích xuất một giá trị từ một đối tượng JSON
SELECT JSON_VALUE('{"name": "John", "age": 30}', '$.name') AS name

--Hàm JSON_QUERY: Dùng để trích xuất một đối tượng JSON từ một đối tượng JSON
SELECT JSON_QUERY('{"name": "John", "age": 30, "address": {"street": "123 Main St.", "city": "New York"}}', '$.address') AS address

--Hàm JSON_MODIFY : Dùng để thay đổi một giá trị trong một đối tượng JSON
SELECT JSON_MODIFY('{"name": "John", "age": 30}', '$.name', 'Jane') AS name

--Hàm ISJSON: Dùng để kiểm tra một chuỗi có phải là một đối tượng JSON hay không
SELECT ISJSON('{"name": "John", "age": 30}') AS is_json

--Hàm OPENJSON: Dùng để chuyển một đối tượng JSON thành một bảng
SELECT * FROM OPENJSON('{"name": "John", "age": 30}')

--Thêm mới dữ liệu JSON:
CREATE TABLE People (
      ID INT PRIMARY KEY,
      Info NVARCHAR(MAX)
  )

DECLARE @info NVARCHAR(MAX)
SET @info = N'{
    "firstName": "Nguyễn",
    "lastName": "Thảo",
    "age": 25,
    "address": {
      "StreetAddress": "290/58 Nơ Trang Long",
      "City": "Việt Nam",
      "State": "VN",
      "postalCode": "76000"
    },
    "PhoneNumber": [
      {"type": "home","number": "212 555-1234"},
      {"type": "fax","number": "646 555-4567"}
    ]
  }'
INSERT INTO People (ID,Info) VALUES (1, @info)

--Truy vấn dữ liệu JSON:
SELECT 
  JSON_VALUE(Info, '$.address.StreetAddress') AS Street,
  JSON_QUERY(Info, '$.skills') AS Skills
FROM People
WHERE ISJSON(Info) > 0

--Update dữ liệu JSON:
UPDATE People
SET Info = JSON_MODIFY(Info, '$.age', 36)
WHERE ID = 1

SELECT 
    JSON_VALUE (Info, '$.age') Age
FROM
    People
WHERE
    ISJSON (Info) > 0
