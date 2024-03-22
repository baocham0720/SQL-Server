--Triggers: là một đối tượng trong SQL Server, nó được sử dụng để thực thi một tập hợp các câu lệnh SQL khi một sự kiện xảy ra
--Trigger được kích hoạt bởi một sự kiện như INSERT, UPDATE, DELETE

--DML Trigger: Là loại trigger được kích hoạt bởi các câu lệnh DML như INSERT, UPDATE hoặc DELETE. Có hai loại DML trigger:
--After trigger: được kích hoạt sau khi sự kiện xảy ra. (được kích hoạt sau)
--Instead of trigger: được kích hoạt thay thế cho sự kiện. (được kích hoạt trước)
/*
Lưu ý: 
-Có 2 bảng inserted và deleted được sử dụng trong trigger. 
-Bảng inserted chứa các bản ghi được thêm vào bởi câu lệnh INSERT hoặc UPDATE. 
-Table deleted chứa các bản ghi bị xóa bởi câu lệnh DELETE hoặc UPDATE.
*/

--AFTER TRIGGER:
--ex: Khi có đơn đặt hàng, và đơn đã xác nhận thanh toán thành công, thì phải cập nhật trạng thái tồn kho giảm đi = số lượng sản phẩm có trong đơn hàng đã mua.
--Gắn Trigger để nó tự động cập nhật 
CREATE TRIGGER trg_OrderItems_Update_ProductStock --trg: tiếp đầu ngữ
ON order_items
AFTER INSERT --After Trigger
AS
BEGIN
    BEGIN TRY
        UPDATE stocks
            SET quantity = s.quantity - i.quantity
        FROM
        stocks as s
        INNER JOIN inserted AS i ON s.product_id = i.product_id
        INNER JOIN orders AS o ON o.order_id = i.order_id AND o.store_id = s.store_id;
    END TRY
    BEGIN CATCH
        -- Nếu có lỗi xảy ra, hiển thị thông tin lỗi
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
        THROW --ném lỗi
    END CATCH
END

--DEMO 
SELECT * FROM order_items
INSERT 
    order_items
    (order_id, item_id, product_id, quantity, price.discount)
VALUES
    (1615, 4, 1, 1, 379.99, 3.00 )  
--xem tồn kho trước:
--store_id = 3
--quantity = 14
SELECT * FROM stocks WHERE product_id = 1
--sẽ trả về số lượng tồn kho là 13

--Ví dụ 2: Tạo một trigger AFTER để ngăn chặn việc cập nhật / xóa đơn hàng khi đơn hàng (orders) có trạng thái order_status = 4 (COMPLETED)
/*
CREATE TRIGGER trg_Orders_Prevent_UpdateDelete
ON orders
AFTER UPDATE, DELETE -- Ngăn cách nhau bởi dấy phẩu khi có nhiều action
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE [order_status] = 4)
    BEGIN
        PRINT 'Cannot update order having status = 4 (COMPLETED).'
        ROLLBACK -- Hủy lệnh UPDATE trước đó vào orders
    END

    IF EXISTS (SELECT * FROM deleted WHERE [order_startus] = 4)
    BEGIN
        PRINT 'Cannot delete order having status = 4 (COMPLETED).'
        ROLLBACK -- Hủy lệnh DELETE trước đó vào orders
    END
END
*/

--INSTEAD OF Trigger : à một trigger cho phép bạn bỏ qua một câu lệnh INSERT, DELETE hoặc UPDATE đối với một bảng hoặc một view và thay vào đó thực thi các câu lệnh khác được định nghĩa trong trigger. Thực tế, việc INSERT, DELETE hoặc UPDATE không xảy ra.
--Ví dụ: Tạo một trigger INSTEAD OF để ngăn chặn việc thêm dữ liệu vào bảng customers
/*
CREATE TRIGGER trg_brands_PreventInsert
ON brands
INSTEAD OF INSERT --Instead Trigger và ngăn câu lệnh INSERT chạy
AS
BEGIN
    PRINT 'Cannot insert data into the Customers table.'
END

INSERT brands
    (brand_name)
VALUES
    ('BMW')
*/

--DDL Trigger : tác động trên phạm vi là DATABASE, ngăn chặn việc tạo mới hoạc sửa xoá một database
--Ví dụ: Tạo một trigger để ngăn chặn việc xóa bảng customers
/*
CREATE TRIGGER trg_customers_Prevent_DropTable
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[customers]') AND type in (N'U'))
    BEGIN
        PRINT 'Cannot drop the table: Customers.'
        ROLLBACK
    END
END 
*/

--Disable Trigger: Vô hiệu hóa hoạt động của một Trigger

DISABLE TRIGGER dbo.trg_customers_LogAlterTable 
ON dbo.customers


--Enable Trigger : Kích hoạt lại Trigger
ENABLE TRIGGER [schema_name.][trigger_name] 
ON [object_name | DATABASE | ALL SERVER]

--List ALl Triggers : Liệt kê danh sách tất cả Triggers
SELECT  
    name,
    is_instead_of_trigger
FROM 
    sys.triggers  
WHERE 
    type = 'TR';


