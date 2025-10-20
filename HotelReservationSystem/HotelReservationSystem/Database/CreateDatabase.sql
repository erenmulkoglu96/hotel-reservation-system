CREATE DATABASE HotelReservationDB;
GO

USE HotelReservationDB;
GO

CREATE TABLE RoomTypes (
    RoomTypeId INT PRIMARY KEY IDENTITY(1,1),
    TypeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(255)
);

CREATE TABLE Rooms (
    RoomId INT PRIMARY KEY IDENTITY(1,1),
    RoomNumber NVARCHAR(10) NOT NULL UNIQUE,
    RoomTypeId INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Capacity INT NOT NULL,
    Description NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    CONSTRAINT FK_Rooms_RoomTypes FOREIGN KEY (RoomTypeId) REFERENCES RoomTypes(RoomTypeId)
);

CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone NVARCHAR(20),
    IdentityNumber NVARCHAR(11),
    CreatedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE Reservations (
    ReservationId INT PRIMARY KEY IDENTITY(1,1),
    CustomerId INT NOT NULL,
    RoomId INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    TotalPrice DECIMAL(10,2) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Pending',
    CreatedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Reservations_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
    CONSTRAINT FK_Reservations_Rooms FOREIGN KEY (RoomId) REFERENCES Rooms(RoomId),
    CONSTRAINT CHK_CheckOutAfterCheckIn CHECK (CheckOutDate > CheckInDate)
);

CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Role NVARCHAR(20) DEFAULT 'Receptionist',
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE()
);

INSERT INTO RoomTypes (TypeName, Description) VALUES 
('Single', 'Tek kişilik standart oda'),
('Double', 'İki kişilik konforlu oda'),
('Suite', 'Lüks süit oda');

INSERT INTO Rooms (RoomNumber, RoomTypeId, Price, Capacity, Description) VALUES 
('101', 1, 500.00, 1, 'Deniz manzaralı single oda'),
('102', 1, 500.00, 1, 'Bahçe manzaralı single oda'),
('201', 2, 800.00, 2, 'Balkonlu double oda'),
('202', 2, 800.00, 2, 'Jakuzili double oda'),
('301', 3, 1500.00, 4, 'King suite - deniz manzarası');

INSERT INTO Users (Username, Password, FullName, Role) VALUES 
('admin', 'admin123', 'Sistem Yöneticisi', 'Admin');
