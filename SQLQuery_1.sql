--Tao Database
CREATE DATABASE Batch38

USE Batch38
GO
--Tao Table
CREATE TABLE categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    category_name NVARCHAR(50) NOT NULL, --không cho phép rỗng
    description NVARCHAR(500) NULL -- cho phép rỗng
)
--Khoá chính:
-- NOT NULL
-- IDENTITY là định danh tự tăng khong trùng lăp
-- 1: là bắt đầu giá trị 1
-- 1: bước nhảy

--xem danh sách các tables trong database hiện tại
select * from sys.tables 

--chèn 2 record
INSERT dbo.categories
         (category_id, category_name, description)
 VALUES 
       ('Mobile', 'Description mobile' ),
     --chèn nhiều record vào table thì sử dụng dấu, và ()
       (2, 'Aplle', 'Description Apple' ),
       (3, 'xiaomi', N'Điện thoại xiaomi') --có N để không lỗi tiếng việt
  
--tạo bảng brands:
CREATE TABLE brands (
    brand_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    brand_name NVARCHAR(50) NOT NULL, --không cho phép rỗng
    description NVARCHAR(500) NULL -- cho phép rỗng
)
--Cách đặt tên côt:
--1. snack case: product_name
--2. Pascal Case: ProductName
--3. camel Case: productName

-- Tạo bảng products
CREATE TABLE dbo.products (
    product_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    product_name NVARCHAR(255) NOT NULL,
    price DECIMAL(18, 2) DEFAULT 0, -- (16 so 9, 99)
    --DEFAULT 0 là thiết lập giá trị mặc đinh chi trường dữ liệu
    discount DECIMAL(18, 2) DEFAULT 0,
    category_id INT NOT NULL,
    brand_id INT NOT NULL,
    description NVARCHAR(500) NULL,
    model_year SMALLINT,
    create_at DATETIME2 -- ngày thêm mới sp yy--mm--dd
)

--Định nghiã khoá chính, khoá ngoại
ALTER TABLE dbo.products
ADD CONSTRAINT PK_products_product_id PRIMARY KEY (product_id)

--khóa ngoại của category_id trong products có quan hệ với
--khoá chính category_id của table categories
ALTER TABLE dbo.products
ADD CONSTRAINT PK_products_category_id FOREIGN KEY (category_id) 
     REFERENCES dbo.categories (category_id)

--khóa ngoại của brand_id trong products có quan hệ với
--khoá chính brand_id của table brands
 ALTER TABLE dbo.products
ADD CONSTRAINT PK_products_brand_id FOREIGN KEY (brand_id) 
     REFERENCES dbo.brands (brand_id)  

INSERT products (
    product_name,
    price,
    category_id,
    brand_id,
    description,
    model_year
) 
VALUES (
    N'Road Bike',
    500,
    3,
    4,
    N'Road bike for paved roads',
    2022
)     

-- Sửa tên cột trong table
 EXEC sp_rename 'products.create_date', 'create_at', 'COLUMN';

--Thay đổi data type cho cột
ALTER TABLE dbo.products
ALTER COLUMN model_year INT

--Xoá cột
ALTER TABLE dbo.products
DROP COLUMN model_year

--Thêm cột:
--thêm bằng đồ hoạ thì nhấn chuột phaỉ -> Design
--thêm bằng lệnh:
ALTER TABLE dbo.products
ADD moder_year SMALLINT

--Thay đổi cấu trúc column
-- description NVARCHAR(500) qua NVARCHAR(100)
ALTER TABLE dbo.products
ALTER COLUMN description NVARCHAR(100) NULL

--UPDATE: THAY ĐỔI DỮ KIỆU TRONG BẢNG
--đổi tên xiaomi = Xiami tại dòng category_id=3
UPDATE dbo.products SET 
product_name = N'ip 15' 
WHERE product_id = 3 --bắt buộc dùng mệnh đề WHERE để xác phạm vi tác động

--DELETE: XOÁ DỮ LIỆU TRONG BẢNG
--xoá data có brand_id=6
DELETE dbo.brands
WHERE brand_id = 6
--xoá toàn bộ record trong table 
DELETE dbo.brands
--hoặc dùng lệnh xoá tương đương
 TRUNCATE TABLE dbo.brands

--Contraint UNIQUE
ALTER TABLE dbo.categories
ADD CONSTRAINT UQ__categories_category_name UNIQUE (category_name)

select * from categories 
INSERT categories (
    category_name
)
VALUES (N'Electric')

--Create CHECK (price > 0)
ALTER TABLE dbo.products
ADD CONSTRAINT CK_products_price CHECK (price > 0)
GO

-- Create CHECK (discount >=0 AND discount <= 90)
ALTER TABLE dbo.products
ADD CONSTRAINT CK_products_discount CHECK (discount >= 0 AND discount <= 90)
GO
