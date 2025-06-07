-- =======================================
-- 1️⃣ TẠO BẢNG
-- =======================================

IF EXISTS (  
    SELECT name  
    FROM sys.databases  
    WHERE name = 'QuanLyKS'  
)  
BEGIN  
    USE master
    ALTER DATABASE QuanLyKS SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QuanLyKS;
END  
GO

Create database QuanLyKS
go
Use QuanLyKS
go

CREATE TABLE NguoiDung (
    MaNguoiDung INT PRIMARY KEY IDENTITY,
    TenDangNhap NVARCHAR(50) UNIQUE NOT NULL,
    MatKhau VARCHAR(100) NOT NULL,  -- Giả định lưu mật khẩu dạng text (demo)
    HoTen NVARCHAR(100),
    VaiTro NVARCHAR(20)  -- Admin, NhanVien, KhachHang
);

CREATE TABLE Phong (
    MaPhong INT PRIMARY KEY,
    TenPhong NVARCHAR(50),
    LoaiPhong NVARCHAR(50),
    TrangThai NVARCHAR(20) -- 'Trong', 'DaDat', 'DangO'
);

CREATE TABLE DatPhong (
    MaDatPhong INT PRIMARY KEY IDENTITY,
    MaPhong INT FOREIGN KEY REFERENCES Phong(MaPhong)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    MaNguoiDung INT FOREIGN KEY REFERENCES NguoiDung(MaNguoiDung)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    NgayDat DATE,
    NgayNhanPhong DATE,
    NgayTraPhong DATE,
    TrangThai NVARCHAR(20), -- 'DatTruoc', 'DaCheckIn', 'DaCheckOut'
    CONSTRAINT chk_NgayNhan_NgayTra CHECK (NgayNhanPhong <= NgayTraPhong)
);

-- =======================================
-- 2️⃣ DỮ LIỆU MẪU (5 dòng mỗi bảng)
-- =======================================

INSERT INTO NguoiDung (TenDangNhap, MatKhau, HoTen, VaiTro) VALUES
('admin', 'admin123', N'Nguyễn Văn A', 'Admin'),
('nhanvien1', 'nv1123', N'Trần Thị B', 'NhanVien'),
('khach1', 'khachpass1', N'Lê Văn C', 'KhachHang'),
('khach2', 'khachpass2', N'Phạm Thị D', 'KhachHang'),
('khach3', 'khachpass3', N'Hoàng Văn E', 'KhachHang');

INSERT INTO Phong (MaPhong, TenPhong, LoaiPhong, TrangThai) VALUES
(101, N'Phòng 101', N'Tiêu chuẩn', 'Trong'),
(102, N'Phòng 102', N'Tiêu chuẩn', 'Trong'),
(201, N'Phòng 201', N'Cao cấp', 'Trong'),
(202, N'Phòng 202', N'Cao cấp', 'Trong'),
(301, N'Phòng 301', N'Suite', 'Trong');

INSERT INTO DatPhong (MaPhong, MaNguoiDung, NgayDat, NgayNhanPhong, NgayTraPhong, TrangThai) VALUES
(101, 3, '2025-05-05', NULL, '2025-05-08', 'DatTruoc'),
(102, 4, '2025-05-04', NULL, '2025-05-07', 'DatTruoc'),
(201, 5, '2025-05-01', '2025-05-02', '2025-05-06', 'DaCheckIn'),
(202, 3, '2025-05-01', '2025-05-01', '2025-05-03', 'DaCheckOut'),
(301, 4, '2025-05-06', NULL, '2025-05-09', 'DatTruoc');

--------------------
INSERT INTO Phong (MaPhong, TenPhong, LoaiPhong, TrangThai) VALUES
(302, N'Phòng 302', N'Tiêu chuẩn', N'Trống');


-- =======================================
-- 3️⃣ STORED PROCEDURE: Đăng nhập
-- =======================================

CREATE PROCEDURE sp_DangNhap
    @TenDangNhap NVARCHAR(50),
    @MatKhau NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT MaNguoiDung, HoTen, VaiTro
    FROM NguoiDung
    WHERE TenDangNhap = @TenDangNhap AND MatKhau = @MatKhau;
END;
Go
-- =======================================
-- 4️⃣ STORED PROCEDURE: Hiển thị danh sách phòng
-- =======================================

CREATE PROCEDURE sp_HienThiDanhSachPhong
AS
BEGIN
    SET NOCOUNT ON;
    SELECT MaPhong, TenPhong, LoaiPhong, TrangThai
    FROM Phong
    ORDER BY MaPhong;
END;
Go
-- =======================================
-- 5️⃣ STORED PROCEDURE: Check-in
-- =======================================

CREATE PROCEDURE sp_CheckIn
    @MaDatPhong INT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM DatPhong WHERE MaDatPhong = @MaDatPhong AND TrangThai = 'DatTruoc')
    BEGIN
        UPDATE DatPhong
        SET TrangThai = 'DaCheckIn', NgayNhanPhong = GETDATE()
        WHERE MaDatPhong = @MaDatPhong;
        
        DECLARE @MaPhong INT;
        SELECT @MaPhong = MaPhong FROM DatPhong WHERE MaDatPhong = @MaDatPhong;
        
        UPDATE Phong
        SET TrangThai = 'DangO'
        WHERE MaPhong = @MaPhong;
        
        PRINT N'Check-in thành công.';
    END
    ELSE
    BEGIN
        PRINT N'Đơn đặt phòng không hợp lệ hoặc đã check-in.';
    END
END;

-- Cập nhật trạng thái phòng
CREATE PROCEDURE sp_UpdatePhong
    @MaPhong INT,
    @TrangThai NVARCHAR(20)
AS
BEGIN
    UPDATE Phong
    SET TrangThai = @TrangThai
    WHERE MaPhong = @MaPhong
END
GO

ALTER PROCEDURE sp_UpdatePhong
    @MaPhong INT,
    @TenPhong NVARCHAR(50),
    @LoaiPhong NVARCHAR(50),
    @TrangThai NVARCHAR(20)
AS
BEGIN
    UPDATE Phong
    SET 
        TenPhong = @TenPhong,
        LoaiPhong = @LoaiPhong,
        TrangThai = @TrangThai
    WHERE MaPhong = @MaPhong
END
GO

-- Xóa phòng
CREATE PROCEDURE sp_DeletePhong
    @MaPhong INT
AS
BEGIN
    DELETE FROM Phong
    WHERE MaPhong = @MaPhong
END
GO
-- =======================================
-- 6️⃣ CÁCH TEST
-- =======================================

-- Đăng nhập (Admin)
EXEC sp_DangNhap @TenDangNhap = 'admin', @MatKhau = 'admin123';

-- Hiển thị danh sách phòng
EXEC sp_HienThiDanhSachPhong;

-- Check-in đơn đặt phòng MaDatPhong = 1 (khách1 đặt phòng 101)
EXEC sp_CheckIn @MaDatPhong = 1;

CREATE PROCEDURE sp_InsertPhong
    @MaPhong INT,
    @TenPhong NVARCHAR(50),
    @LoaiPhong NVARCHAR(50),
    @TrangThai NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem mã phòng đã tồn tại chưa
    IF EXISTS (SELECT 1 FROM Phong WHERE MaPhong = @MaPhong)
    BEGIN
        PRINT N'Mã phòng đã tồn tại!';
        RETURN;
    END

    -- Thêm phòng mới vào bảng
    INSERT INTO Phong (MaPhong, TenPhong, LoaiPhong, TrangThai)
    VALUES (@MaPhong, @TenPhong, @LoaiPhong, @TrangThai);
END;
go

CREATE PROCEDURE sp_TimKiemPhong
    @LoaiPhong NVARCHAR(50) = NULL,
    @TrangThai NVARCHAR(50) = NULL
AS
BEGIN
    SELECT * FROM Phong
    WHERE (@LoaiPhong IS NULL OR LoaiPhong = @LoaiPhong)
      AND (@TrangThai IS NULL OR TrangThai = @TrangThai)
END
