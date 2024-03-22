--Indexs (chỉ mục) là cấu trúc dữ liệu được sử dụng để tăng tốc độ truy vấn và tìm kiếm dữ liệu trong cơ sở dữ liệu. Chúng giúp tối ưu hóa hiệu suất truy vấn bằng cách tạo ra một cấu trúc dữ liệu phụ bên cạnh bảng gốc, có thể được sắp xếp và tìm kiếm nhanh hơn.
-- Tạo cấu trúc bảng customer_index
CREATE TABLE dbo.customer_index (
	[customer_id] [int]  NOT NULL,
	[first_name] [nvarchar](255) NOT NULL,
	[last_name] [nvarchar](255) NOT NULL,
	[phone] [varchar](25) NOT NULL,
	[email] [varchar](150) NOT NULL,
	[birthday] [date] NULL,
	[street] [nvarchar](255) NOT NULL,
	[city] [nvarchar](50) NOT NULL,
	[state] [nvarchar](50) NOT NULL,
	[zip_code] [varchar](5) NULL,
);
-- Xõa dữ liệu nếu có
DELETE FROM dbo.customer_index
-- Đổ dữ liệu từ table customers, sắp xếp theo birthday
INSERT INTO dbo.customer_index
SELECT [customer_id], [first_name], [last_name], [phone], [email],
       CONVERT(date, [birthday], 103), [street], [city], [state], [zip_code]
FROM dbo.customers ORDER BY [birthday],[first_name];
--Check xem có index không
EXEC sp_helpindex 'customer_index';
-- Xem dữ liệu hiện tại
SELECT * FROM dbo.customer_index

--Check thời gian thực hiện truy vấn:

--Kiểm tra thời gian và tài nguyên của một truy vấn:
 --Để xem thời gian thực hiện truy vấn
 SET STATISTICS TIME ON;
 --Để xem tài nguyên thực hiện truy vấn
 SET STATISTICS IO ON;
 -- Truy vấn SQL của bạn ở đây
 -- ....
SELECT customer_id FROM dbo.customer_index WHERE customer_id = 5
 --Tắt đi sau khi truy vấn thực hiện
 SET STATISTICS TIME OFF;
 SET STATISTICS IO OFF;

--Sử dụng hàm GETDATE():
--Trước khi thực thi truy vấn, ghi lại thời điểm bắt đầu bằng cách sử dụng hàm GETDATE():
DECLARE @StartTime DATETIME;
SET @StartTime = GETDATE();
--Sau khi thực thi truy vấn, ghi lại thời điểm kết thúc:
DECLARE @EndTime DATETIME;
SET @EndTime = GETDATE();
--Để tính thời gian thực hiện, sử dụng phép tính:
DECLARE @ExecutionTime FLOAT;
SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
PRINT 'Execution Time: ' + CAST(@ExecutionTime AS NVARCHAR(20)) + ' seconds';

--Cấu trúc B-TREE: Là một cấu trúc dữ liệu được sử dụng để lưu trữ dữ liệu trong cơ sở dữ liệu.
--Heap Structures: Heap là một cấu trúc bảng không có Clustered index. Các dòng không được sắp xếp theo thứ tự nào cả
--0,0298702 : chưa dùng index
--row là 1445
SELECT customer_id FROM dbo.customer_index WHERE customer_id = 5

-- Clustered index : là một loại chỉ mục được tạo ra để sắp xếp và lưu trữ dữ liệu trong một bảng theo một thứ tự nhất định. Khi một clustered index được tạo, dữ liệu trong bảng sẽ được tổ chức thành một cấu trúc gom cụm dựa trên giá trị của chỉ mục đó.
--Chỉ có duy nhất 1 cluster trong 1 bảng
--ex:
--Tạo clustered index
CREATE CLUSTERED INDEX CIX_customers_index_id --CIX: tiếp đầu ngữ
ON dbo.customer_index (customer_id ASC)
--0,003125 : khi dùng index
--row: 1

--Nonclustered index: là một loại chỉ mục được tạo ra để cải thiện hiệu suất tìm kiếm và truy xuất dữ liệu trong một bảng. Nonclustered index lưu trữ dữ liệu chỉ mục riêng biệt và không sắp xếp dữ liệu trong bảng dựa trên chỉ mục đó.
SELECT customer_id, phone FROM dbo.customer_index WHERE phone = '0968411372'
--Clustered Index seek: Hành động --> quét chỉ mục
--Estimated Opertator Cost: Chi phí thực thi (0.0256122)
--...Rows to be Read: 1445 dòng
CREATE UNIQUE NONCLUSTERED INDEX UIX_customer_index_phone ON customer_index (phone)
-- 0,003125
--row: 1
SELECT customer_id, phone, first_name FROM dbo.customer_index WHERE phone = '0968411372'
--Covering index: là khi nonclustered index có thể thỏa mãn tất cả các cột cần select của một câu truy vấn.

--UNIQUE 
CREATE UNIQUE INDEX UIX_customers_index_email
ON dbo.customer_index(email)
INCLUDE(first_name,last_name)

--Để tạo, xóa và đổi tên index trong SQL Server, bạn có thể sử dụng các câu lệnh SQL sau đây:

--Tạo index:
/*
Tạo Clustered Index:
CREATE CLUSTERED INDEX [IndexName] ON [TableName] ([Column1], [Column2], ...)

Tạo Nonclustered Index:
CREATE NONCLUSTERED INDEX [IndexName] ON [TableName] ([Column1], [Column2], ...)

Tạo Unique Index:
CREATE UNIQUE INDEX [IndexName] ON [TableName] ([Column1], [Column2], ...)

Tạo Columnstore Index:
CREATE CLUSTERED COLUMNSTORE INDEX [IndexName] ON [TableName]

Tạo Full-Text Index:
CREATE FULLTEXT INDEX ON [TableName] ([Column1], [Column2], ...)

Tạo Spatial Index:
CREATE SPATIAL INDEX [IndexName] ON [TableName] ([Column1])

Xóa index:
DROP INDEX [IndexName] ON [TableName]

Xóa clustered index:
ALTER TABLE [TableName] DROP CONSTRAINT [IndexName]

Đổi tên index:
EXEC sp_rename '[TableName].[OldIndexName]', '[NewIndexName]', 'INDEX'

Đổi tên clustered index:
EXEC sp_rename '[TableName].[OldIndexName]', '[NewIndexName]', 'OBJECT'
*/