-- 3. Tạo lại database
CREATE DATABASE QuanLyBanHang;
GO

USE QuanLyBanHang;
GO

-- 4. Tạo bảng KHUVUC
CREATE TABLE KHUVUC (
    MaKhuVuc_ID INT PRIMARY KEY,
    TenKhuVuc NVARCHAR(100),
    MoTa NVARCHAR(255)
);

-- 5. Tạo bảng DANHMUC (tự liên kết)
CREATE TABLE DANHMUC (
    MaDanhMuc_ID INT PRIMARY KEY,
    TenDanhMuc NVARCHAR(100),
    MaDanhMuc_Cha INT NULL
);

-- 6. Tạo bảng DONGIA (chưa liên kết đến MENUDOUONG ở đây vì mối quan hệ được tham chiếu ngược)
CREATE TABLE DONGIA (
    DonGia_ID INT PRIMARY KEY,
    MaDoUong_ID INT,
    TuNgay DATE,
    DenNgay DATE,
    MoTa NVARCHAR(255)
);

-- 7. Tạo bảng BAN
CREATE TABLE BAN (
    MaBan_ID INT PRIMARY KEY,
    TenBan NVARCHAR(100),
    TrangThai NVARCHAR(50),
    MoTa NVARCHAR(255),
    MaKhuVuc_ID INT,
    FOREIGN KEY (MaKhuVuc_ID) REFERENCES KHUVUC(MaKhuVuc_ID)
);

-- 8. Tạo bảng MENUDOUONG
CREATE TABLE MENUDOUONG (
    MaDoUong_ID INT PRIMARY KEY,
    TenDoUong NVARCHAR(100),
    DonGia_ID INT,
    MaDanhMuc_ID INT,
    FOREIGN KEY (DonGia_ID) REFERENCES DONGIA(DonGia_ID),
    FOREIGN KEY (MaDanhMuc_ID) REFERENCES DANHMUC(MaDanhMuc_ID)
);

-- 9. Tạo bảng HOADON
CREATE TABLE HOADON (
    MaHoaDon_ID INT PRIMARY KEY,
    MaBan_ID INT,
    TongTien DECIMAL(18,2),
    NgayBan DATE,
    FOREIGN KEY (MaBan_ID) REFERENCES BAN(MaBan_ID)
);

-- 10. Tạo bảng CHITIETHOADON
CREATE TABLE CHITIETHOADON (
    MaChiTiet_ID INT PRIMARY KEY,
    MaHoaDon_ID INT,
    MaDoUong_ID INT,
    DonGia DECIMAL(18,2),
    SoLuong INT,
    FOREIGN KEY (MaHoaDon_ID) REFERENCES HOADON(MaHoaDon_ID),
    FOREIGN KEY (MaDoUong_ID) REFERENCES MENUDOUONG(MaDoUong_ID)
);

-- Insert data into KHUVUC (Areas)
INSERT INTO KHUVUC (MaKhuVuc_ID, TenKhuVuc, MoTa) VALUES
(1, N'Tầng trệt', N'Khu vực sảnh chính tầng trệt'),
(2, N'Tầng 1', N'Khu vực tầng 1 có ban công'),
(3, N'Sân vườn', N'Khu vực ngoài trời có cây xanh'),
(4, N'VIP', N'Khu vực dành cho khách VIP'),
(5, N'Góc học tập', N'Khu vực yên tĩnh dành cho học tập và làm việc');

-- Insert data into DANHMUC (Categories)
INSERT INTO DANHMUC (MaDanhMuc_ID, TenDanhMuc, MaDanhMuc_Cha) VALUES
(1, N'Đồ uống', NULL),
(2, N'Cà phê', 1),
(3, N'Trà', 1),
(4, N'Nước ép', 1),
(5, N'Sinh tố', 1),
(6, N'Cà phê Việt Nam', 2),
(7, N'Cà phê Ý', 2),
(8, N'Trà trái cây', 3),
(9, N'Trà sữa', 3),
(10, N'Nước ép trái cây tươi', 4);

-- Insert data into DONGIA (Prices)
INSERT INTO DONGIA (DonGia_ID, MaDoUong_ID, TuNgay, DenNgay, MoTa) VALUES
(1, 1, '2024-01-01', '2024-12-31', N'Giá cà phê đen'),
(2, 2, '2024-01-01', '2024-12-31', N'Giá cà phê sữa'),
(3, 3, '2024-01-01', '2024-12-31', N'Giá bạc xỉu'),
(4, 4, '2024-01-01', '2024-12-31', N'Giá cappuccino'),
(5, 5, '2024-01-01', '2024-12-31', N'Giá latte'),
(6, 6, '2024-01-01', '2024-12-31', N'Giá americano'),
(7, 7, '2024-01-01', '2024-06-30', N'Giá trà đào - khuyến mãi'),
(8, 7, '2024-07-01', '2024-12-31', N'Giá trà đào - bình thường'),
(9, 8, '2024-01-01', '2024-12-31', N'Giá trà vải'),
(10, 9, '2024-01-01', '2024-12-31', N'Giá trà sữa truyền thống');

-- Insert data into BAN (Tables)
INSERT INTO BAN (MaBan_ID, TenBan, TrangThai, MoTa, MaKhuVuc_ID) VALUES
(1, N'Bàn 1', N'Trống', N'Bàn 4 người', 1),
(2, N'Bàn 2', N'Trống', N'Bàn 2 người', 1),
(3, N'Bàn 3', N'Đang phục vụ', N'Bàn 6 người', 1),
(4, N'Bàn 4', N'Trống', N'Bàn 4 người', 2),
(5, N'Bàn 5', N'Đang phục vụ', N'Bàn 8 người', 2),
(6, N'Bàn 6', N'Trống', N'Bàn 2 người', 3),
(7, N'Bàn 7', N'Trống', N'Bàn 4 người', 3),
(8, N'Bàn VIP 1', N'Đã đặt trước', N'Bàn 10 người', 4),
(9, N'Bàn học 1', N'Trống', N'Bàn học tập 4 người', 5),
(10, N'Bàn học 2', N'Đang phục vụ', N'Bàn học tập 6 người', 5);

-- Insert data into MENUDOUONG (Drinks Menu)
INSERT INTO MENUDOUONG (MaDoUong_ID, TenDoUong, DonGia_ID, MaDanhMuc_ID) VALUES
(1, N'Cà phê đen', 1, 6),
(2, N'Cà phê sữa', 2, 6),
(3, N'Bạc xỉu', 3, 6),
(4, N'Cappuccino', 4, 7),
(5, N'Latte', 5, 7),
(6, N'Americano', 6, 7),
(7, N'Trà đào', 7, 8),
(8, N'Trà vải', 9, 8),
(9, N'Trà sữa truyền thống', 10, 9),
(10, N'Nước cam ép', NULL, 10);

-- Insert data into HOADON (Bills)
INSERT INTO HOADON (MaHoaDon_ID, MaBan_ID, TongTien, NgayBan) VALUES
(1, 3, 120000.00, '2024-03-15'),
(2, 5, 240000.00, '2024-03-15'),
(3, 10, 95000.00, '2024-03-15'),
(4, 1, 75000.00, '2024-03-16'),
(5, 2, 68000.00, '2024-03-16'),
(6, 8, 350000.00, '2024-03-16'),
(7, 3, 135000.00, '2024-03-17'),
(8, 7, 82000.00, '2024-03-17'),
(9, 5, 175000.00, '2024-03-18'),
(10, 10, 120000.00, '2024-03-18');

-- Insert data into CHITIETHOADON (Bill Details)
INSERT INTO CHITIETHOADON (MaChiTiet_ID, MaHoaDon_ID, MaDoUong_ID, DonGia, SoLuong) VALUES
(1, 1, 1, 25000.00, 2),
(2, 1, 4, 35000.00, 2),
(3, 2, 5, 40000.00, 3),
(4, 2, 7, 30000.00, 4),
(5, 3, 2, 30000.00, 1),
(6, 3, 9, 35000.00, 1),
(7, 3, 1, 25000.00, 1),
(8, 4, 3, 35000.00, 1),
(9, 4, 8, 40000.00, 1),
(10, 5, 6, 34000.00, 2),
(11, 6, 5, 40000.00, 5),
(12, 6, 9, 35000.00, 3),
(13, 6, 7, 30000.00, 2),
(14, 7, 1, 25000.00, 3),
(15, 7, 2, 30000.00, 2),
(16, 8, 4, 35000.00, 1),
(17, 8, 7, 30000.00, 1),
(18, 8, 1, 25000.00, 1),
(19, 9, 5, 40000.00, 2),
(20, 9, 9, 35000.00, 1),
(21, 9, 3, 35000.00, 1),
(22, 9, 7, 30000.00, 1),
(23, 10, 2, 30000.00, 2),
(24, 10, 4, 35000.00, 1),
(25, 10, 8, 40000.00, 1);