--1.
CREATE DATABASE HotelManagement

--2.
CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY NOT NULL,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Mobile VARCHAR(20),
    Email VARCHAR(255)
)
INSERT INTO Customers (FirstName, LastName, Mobile, Email)
VALUES ('Tony', 'Hoo', '0988777111', 'tonyhoo@example.com'),
('Songkon', 'Nee', '0988777112', 'songkonnee@example.com')

ALTER TABLE Bookings
DROP CONSTRAINT FK__Bookings__Custom__3F466844



--3.
CREATE TABLE Rooms (
    RoomNumber INT PRIMARY KEY,
    RoomType VARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    IsAvailable NVARCHAR(100) NOT NULL
)
INSERT INTO Rooms (RoomNumber, RoomType, Price, IsAvailable)
VALUES
(1001, 'Single', 1200, 1),
(1002, 'Double', 1600, 1),
(1003, 'Single', 1200, 0)

--4.
CREATE TABLE  Bookings (
    BookingId INT  PRIMARY KEY,
    CustomerId INT,
    RoomNumber INT,
    CheckInDate DATE,
    CheckOutDate DATE,
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
    FOREIGN KEY (RoomNumber) REFERENCES Rooms(RoomNumber)
)
INSERT INTO Bookings (BookingId, CustomerId, RoomNumber, CheckInDate, CheckOutDate)
VALUES
    (1, 1, 1001, '2024-01-01', '2024-01-05'),
    (2, 2, 1002, '2024-01-02', '2024-01-10')

-- C:
--1.
CREATE VIEW v_roomsAvailable AS
SELECT RoomNumber, RoomType, Price
FROM Rooms
WHERE IsAvailable = 1 

--2.
CREATE VIEW v_roomsWithType AS
SELECT RoomType, COUNT(*) AS NumberOfRooms
FROM Rooms
GROUP BY RoomType

--3.
ALTER TABLE Rooms
ADD CONSTRAINT CK_PriceGreaterThanZero CHECK (Price > 0),
    CONSTRAINT CK_IsAvailableValid CHECK (IsAvailable IN (0, 1))

select * from Customers


