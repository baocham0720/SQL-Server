--ERROR HANDING
-- TRY...CATCH : Là cấu trúc dùng để bắt lỗi trong SQL Server
BEGIN
    BEGIN TRY
        SELECT 1/0 -- Chia một số cho 0
    END TRY
    BEGIN CATCH
        --Bắt lỗi, và hiển ra thành một table
        SELECT  
            ERROR_NUMBER() AS ErrorNumber , --Là hàm trả về mã lỗi của lỗi gần nhất xảy ra.
            ERROR_SEVERITY() AS ErrorSeverity , --Là hàm trả về mức độ nghiêm trọng của lỗi gần nhất xảy ra.
            ERROR_STATE() AS ErrorState , --Là hàm trả về trạng thái của lỗi gần nhất xảy ra.
            ERROR_PROCEDURE() AS ErrorProcedure , --Là hàm trả về tên của stored procedure hay trigger gây ra lỗi gần nhất xảy ra.
            ERROR_LINE() AS ErrorLine , --Là hàm trả về số dòng gây ra lỗi gần nhất xảy ra.
            ERROR_MESSAGE() AS ErrorMessage;  --Là hàm trả về thông điệp lỗi gần nhất xảy ra.
    END CATCH
END

-- RAISERROR : Là câu lệnh dùng để tạo ra một lỗi do người dùng tự định nghĩa.
--ex:
RAISERROR('This is a custom error', 1, 1) --thường để là 1

--THROW : câu lệnh dùng để tạo ra một lỗi do người dùng tự định nghĩa. Do đơn giản hơn RAISERROR nên nên được ưu tiên sử dụng.
--ex1:
THROW 50000, 'This is a custom error', 1 --có nguy cơ xảy ra lỗi và bẫy lỗi
--ex2:
-- Tạo table t1
CREATE TABLE t1(
    id int primary key
);
GO
--
BEGIN TRY
    INSERT INTO t1(id) VALUES(1);
    --  cause error
    INSERT INTO t1(id) VALUES(1);
END TRY
BEGIN CATCH
    PRINT('Raise the caught error again');
    THROW;
END CATCH

--Biến @@ERROR : Là một biến toàn cục, chứa mã lỗi của lỗi gần nhất xảy ra
SELECT 1/0
SELECT @@ERROR
--cho ra kết quả: Msg 8134, Level 16, State 1, Line 1
--Divide by zero error encountered. 8134

--TRANSACTIONS : là một tập hợp các hoạt động được thực hiện như một đơn vị không thể chia rời
/* Các lệnh quản lý transaction
BEGIN TRANSACTION : Dùng để bắt đầu một transaction.

COMMIT TRANSACTION : Dùng để xác nhận toàn bộ một transaction.

COMMIT WORK : Dùng để đánh đấu kết thúc của transaction.

SAVE TRANSACTION : Dùng để tạo một savepoint trong transaction.

ROLLBACK WORK : Dùng để hủy bỏ một transaction.

ROLLBACK TRANSACTION : Dùng để hủy bỏ toàn bộ một transaction.

ROLLBACK TRANSACTION [SavepointName] : Dùng để hủy bỏ một savepoint trong transaction
*/
--Cách sử dụng Transaction
-- Bước 1:  start a transaction
BEGIN TRANSACTION; -- or BEGIN TRAN

-- Bước 2:  Các câu lênh truy vấn bắt đầu ở đây INSERT, UPDATE, and DELETE

-- =====================
-- Chạy xong các câu lệnh trên thì bạn kết thúc TRANSACTION với 1 trong 2 hình thức.
-- =====================

-- Bước 3 -  1. commit the transaction
-- Để xác nhận thay đổi dữ liệu
COMMIT; --nếu 1 trong 3 câu lệnh lỗi thì lệnh này huỷ

-- Bước 3 - 2. rollback -- Hồi lại những thay đổi trong những câu lệnh truy vấn ở trên. 
--(Hủy ko thực hiện nữa, trả lại trạng thái ban đầu lúc chưa chạy)
ROLLBACK;

--ex : Tạo 2 bảng mới invoices và invoice_items
-- Hóa đơn
CREATE TABLE invoices (
  id int IDENTITY(1,1) PRIMARY KEY,
  customer_id int NOT NULL,
  total decimal(10, 2) NOT NULL DEFAULT 0 CHECK (total >= 0)
);
-- Chi tiết các mục ghi vào hóa đơn
CREATE TABLE invoice_items (
  id int IDENTITY(1,1),
  invoice_id int NOT NULL,
  item_name varchar(100) NOT NULL,
  amount decimal(18, 2) NOT NULL CHECK (amount >= 0),
  tax decimal(4, 2) NOT NULL CHECK (tax >= 0),
  PRIMARY KEY (id, invoice_id),
  FOREIGN KEY (invoice_id) REFERENCES invoices (id)
 ON UPDATE CASCADE
 ON DELETE CASCADE
)
--Bây giờ chúng ta tạo một TRANSACTION thực hiện thêm mới dữ liệu vào cho 2 table cùng lúc:
-- Bước 1
BEGIN TRANSACTION; -- or BEGIN TRAN
-- Bước 2
-- Thêm vào invoices
INSERT INTO dbo.invoices (customer_id, total)
VALUES (100, 0);
-- Thêm vào invoice_items
 INSERT INTO dbo.invoice_items (invoice_id, item_name, amount, tax)
VALUES (1, 'Keyboard', 70, 0.08),
       (1, 'Mouse', 50, 0.08);
-- Thay đổi dữ liệu cho record đã chèn vào invoices
UPDATE dbo.invoices
SET total = (SELECT
  SUM(amount * (1 + tax))
FROM invoice_items
WHERE invoice_id = 1);

--Bước 3: xác nhận cho phép thay đổi dữ liệu
COMMIT TRANSACTION; -- or COMMIT
--ROLLBACK TRANSACTION

SELECT * FROM dbo.invoices
SELECT * FROM dbo.invoice_items
--Kết quả của một tập hợp các câu lệnh truy vấn trên:
--Nếu 1 trong 3 câu lệnh THẤT BẠI ==> Tất cả sẽ đều THẤT BẠI, trả lại trạng thái ban đầu.
--Nếu cả 3 THÀNH CÔNG ==> TRANSACTION thành công, dữ liệu được cập nhật.

--Khi lênh trên thay bằng ROLLBACK
-- Bước 1
BEGIN TRANSACTION;
-- Bước 2
-- Thêm vào invoice_items

INSERT INTO dbo.invoice_items (invoice_id, item_name, amount, tax)
VALUES (1, 'Headphone', 80, 0.08),
       (1, 'Mainboard', 30, 0.08);

INSERT INTO dbo.invoice_items (invoice_id, item_name, amount, tax)
VALUES (1, 'TochPad', 20, 0.08),
       (1, 'Camera', 90, 0.08);

INSERT INTO dbo.invoice_items (invoice_id, item_name, amount, tax)
VALUES (1, 'Wifi', 120, 0.08),
       (1, 'Bluetooth', 20, 0.08);

--Bước 3: xác nhận HỦY thay đổi dữ liệu
ROLLBACK TRANSACTION;

----
SELECT * FROM stores
SELECT * from dbo.stores

BEGIN TRANSACTION
	DECLARE @c INT = (SELECT COUNT(*) FROM dbo.stores WHERE phone = 'N/A')
	
	PRINT @c

	IF @c > 0
	BEGIN
		UPDATE dbo.stores SET phone = 'N/A' WHERE phone IS NULL;
		ROLLBACK TRANSACTION;
		PRINT 'yes'
	END
	ELSE
	BEGIN
		PRINT 'no'
	END
COMMIT TRANSACTION