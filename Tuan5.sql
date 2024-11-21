create database tuan5_TCSDL2
use tuan5_TCSDL2
create table KHACHHANG
(
	MAKHACHHANG char(10) primary key,
	TENCONGTY nvarchar(50) not null,
	TENGIAODICH nvarchar(50),
	DIACHI nvarchar(50),
	EMAIL varchar(10) unique,
	DIENTHOAI varchar(11) unique,
	FAX varchar(11) unique
)
create table NHANVIEN
(
	MANHANVIEN char(10) primary key,
	HO nvarchar(20) not null,
	TEN nvarchar(50)not null,
	NGAYSINH date,
	NGAYLAMVIEC datetime,
	DIACHI nvarchar(50),
	DIENTHOAI varchar(11) unique,
	LUONGCOBAN money
		check (LUONGCOBAN > 0),
	PHUCAP money
		check (PHUCAP>0)
)
create table LOAIHANG
(
	MALOAIHANG char(10) primary key,
	TENLOAIHANG nvarchar(50) not null
)
create table NHACUNGCAP
(
	 MACONGTY char(10) primary key,
	 TENCONGTY nvarchar(50) not null,
	 TENGIAODICH nvarchar(50),
	 DIACHI nvarchar(50),
	 DIENTHOAI varchar(11) unique,
	 FAX varchar(11) unique,
	 EMAIL varchar(50) unique
)
create table MATHANG
(
	MAHANG char(10) primary key,
	TENHANG nvarchar(50) not null,
	SOLUONG int
		check (SOLUONG>0),
	DONVITINH nchar(50)not null,
	GIAHANG money
		check (GIAHANG>0),
	MACONGTY char(10) foreign key references NHACUNGCAP(MACONGTY),
	MALOAIHANG char(10) foreign key references LOAIHANG(MALOAIHANG)
)
create table DONDATHANG
(
	SOHOADON char(10) primary key,
	NGAYDATHANG datetime,
	NGAYGIAOHANG datetime,
	NGAYCHUYENHANG datetime,
	NOIGIAOHANG nvarchar(50),
	MAKHACHHANG char(10) foreign key references KHACHHANG(MAKHACHHANG),
	MANHANVIEN char(10) foreign key references NHANVIEN(MANHANVIEN)
)

create table CHITIETDATHANG
(
	GIABAN money
		check (GIABAN>0),
	SOLUONG int
		check (SOLUONG>0),
	MUCGIAMGIA money
		check (MUCGIAMGIA>0),
	primary key(SOHOADON,MAHANG),
	SOHOADON char(10) foreign key references DONDATHANG(SOHOADON),
	MAHANG char(10) foreign key references MATHANG(MAHANG)
)
