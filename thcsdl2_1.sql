-- Tạo database Test4
CREATE DATABASE Test4;
GO

-- Sử dụng database Test4
USE Test4;
GO

-- Tạo bảng KHACHHANG
CREATE TABLE KHACHHANG (
    MAKH CHAR(10) PRIMARY KEY,
    TenCongTy NVARCHAR(255),
    TenGiaoDich NVARCHAR(100),
    DiaChi NVARCHAR(255),
    Email VARCHAR(100),
    DienThoai VARCHAR(11),
    Fax VARCHAR(50)
);
GO

-- Tạo bảng NHANVIEN (giả định cần có để tham chiếu)
CREATE TABLE NHANVIEN (
    MANV CHAR(10) PRIMARY KEY,
    TenNhanVien NVARCHAR(60),
);
GO

-- Tạo bảng CONGTY (giả định cần có để tham chiếu)
CREATE TABLE CONGTY (
    MaCongTy CHAR(25) PRIMARY KEY,
    TenCongTy NVARCHAR(255),
);
GO

-- Tạo bảng LOAIHANG
CREATE TABLE LOAIHANG (
    MaLoaiHang CHAR(30) PRIMARY KEY,
    TenHang NVARCHAR(255),
);
GO

-- Tạo bảng MATHANG
CREATE TABLE MATHANG (
    MaHang CHAR(10) PRIMARY KEY,
    TenHang NVARCHAR(255),
    MaCongTy CHAR(25),
    MaLoaiHang CHAR(30),
    SoLuong INT,
    DnViTinh NVARCHAR(50),
    GiaHang DECIMAL(10, 2),
    FOREIGN KEY (MaCongTy) REFERENCES CONGTY(MaCongTy),
    FOREIGN KEY (MaLoaiHang) REFERENCES LOAIHANG(MaLoaiHang)
);
GO

-- Tạo bảng DONDATHANG
CREATE TABLE DONDATHANG (
    SoHD CHAR(15) PRIMARY KEY,
    MAKH CHAR(10),
    MANV CHAR(10),
    NgayDatHang DATE,
    NgayGiaoHang DATE,
    NgayChuyenHang DATE,
    NoiGiaoHang NVARCHAR(255),
    FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH),
    FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)
);
GO

-- Tạo bảng ChiTietDatHang
CREATE TABLE ChiTietDatHang (
    SoHD CHAR(15),
    MaHang CHAR(10),
    GiaBan MONEY,
    SoLuong INT,
    MucGiamGia DECIMAL(5, 2),
    PRIMARY KEY (SoHD, MaHang),
    FOREIGN KEY (SoHD) REFERENCES DONDATHANG(SoHD),
    FOREIGN KEY (MaHang) REFERENCES MATHANG(MaHang)
);
GO

-- Tạo bảng NhaCungCap
CREATE TABLE NhaCungCap (
    MaCongTy CHAR(10) PRIMARY KEY,
    TenCongTy NVARCHAR(255),
    TenGiaoDich NVARCHAR(255),
    DiaChi NVARCHAR(255),
    DienThoai NVARCHAR(50),
    Fax NVARCHAR(50),
    Email NVARCHAR(255)
);
GO

