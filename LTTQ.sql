IF EXISTS (SELECT * FROM sys.databases WHERE name = N'HoSoSinhVien')
BEGIN
    -- Đóng tất cả các kết nối đến cơ sở dữ liệu
    EXECUTE sp_MSforeachdb 'IF ''?'' = ''HoSoSinhVien'' 
    BEGIN
        DECLARE @sql AS NVARCHAR(MAX) = ''USE [?]; ALTER DATABASE [?] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;''
        EXEC (@sql)
    END'
    -- Xóa tất cả các kết nối tới cơ sở dữ liệu (thực hiện qua hệ thống master)
    USE master;
    -- Xóa cơ sở dữ liệu nếu tồn tại
    DROP DATABASE HoSoSinhVien;
END

create database HoSoSinhVien;
go

use HoSoSinhVien;
go

-- Tạo bảng LOP
CREATE TABLE LOP (
    MALOP VARCHAR(10) PRIMARY KEY,
    TENLOP NVARCHAR(100) NOT NULL,
    SISO INT CHECK (SISO > 0)
);

-- Tạo bảng SINHVIEN
CREATE TABLE SINHVIEN (
    MASV VARCHAR(10) PRIMARY KEY,
    TENSV NVARCHAR(100) NOT NULL,
    NGSINH DATE CHECK (NGSINH <= GETDATE()),
    MALOP VARCHAR(10),
);

-- Tạo bảng SINHVIEN_LOPHOC
CREATE TABLE SINHVIEN_LOPHOC (
    MASV VARCHAR(10),
    MALOP VARCHAR(10),
    PRIMARY KEY (MASV, MALOP),
    FOREIGN KEY (MASV) REFERENCES SINHVIEN(MASV),
    FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)
);
-- Chèn dữ liệu vào bảng LOP trước
INSERT INTO LOP (MALOP, TENLOP, SISO) VALUES
('L01', N'Công nghệ thông tin 1', 40),
('L02', N'Khoa học máy tính', 35),
('L03', N'Hệ thống thông tin', 30);

-- Chèn dữ liệu vào bảng SINHVIEN
INSERT INTO SINHVIEN (MASV, TENSV, NGSINH, MALOP) VALUES
('SV01', N'Nguyễn Văn A', '2002-01-15', 'L01'),
('SV02', N'Trần Thị B', '2001-09-20', 'L02'),
('SV03', N'Lê Văn C', '2002-12-01', 'L03');

-- Chèn dữ liệu vào bảng SINHVIEN_LOPHOC
INSERT INTO SINHVIEN_LOPHOC (MASV, MALOP) VALUES
('SV01', 'L01'),
('SV02', 'L02'),
('SV03', 'L03');
