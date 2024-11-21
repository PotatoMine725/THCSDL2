drop database if exists TCSDL2
create database TCSDL2
go
use TCSDL2
create table QuocGia
(
	maQG char(10) not null primary key,
	tenQG nvarchar(50) not null
)
create table Tinh_TP
(
	maTTP char(10) not null primary key,
	tenTTP nvarchar(50) not null,
	QGNo char(10) foreign key references QuocGia(maQG)
)
create table QuanHuyen
(
	maQH char(10) not null primary key,
	tenQH nvarchar(50) not null,
	TTPNo char(10) foreign key references Tinh_TP(maTTP)
)
create table PhuongXa
(
	maPX char(10) not null primary key,
	tenPX nvarchar(50) not null,
	QuanHuyenNo char(10) foreign key references QuanHuyen(maQH)
)
create table KHACHHANG
(
	MAKHACHHANG char(10) primary key,
	TENCONGTY nvarchar(50) not null,
	TENGIAODICH nvarchar(50),
	DIACHI nvarchar(50),
	EMAIL varchar(10) unique,
	DIENTHOAI varchar(11) unique,
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

--Yêu cầu 2:
alter table CHITIETDATHANG
	add constraint DF_CHITIETDATHANG_SOLUONG 
		default 1 for soluong,
		constraint DF_CHITIETDATHANG_MUCGIAMGIA
		default 0 for mucgiamgia
--Yêu cầu 3:
alter table DONDATHANG
	add constraint CK_DONDATHANG_NGAYGIAOHANG 
		check (NGAYGIAOHANG >= NGAYDATHANG),
		constraint CK_DONDATHANG_NGAYCHUYENHANG
		check (NGAYCHUYENHANG >= NGAYDATHANG)
--Yêu cầu 4:
alter table NHANVIEN
	add constraint CK_NHANVIEN_NGAYSINH
		check (DATEDIFF(YEAR, NGAYSINH, GETDATE()) >= 18 AND DATEDIFF(YEAR, NGAYSINH, GETDATE()) <=60)

--Ràng buộc cho bảng KHACHHANG
alter table KHACHHANG
	drop column DIACHI
alter table KHACHHANG
	add soNhaTenDuong nvarchar(100),
		PXNo char(10) foreign key references PhuongXa(maPX)
			on delete
				cascade
			on update
				cascade,
		constraint CK_KHACHHANG_EMAIL check (Email like '[a-z]%@%'),
		constraint CK_KHACHHANG_DIENTHOAI
		check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
				or DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
--Ràng buộc cho bảng DONDATHANG
alter table DONDATHANG
	drop column NOIGIAOHANG
alter table DONDATHANG
	add soNhaTenDuong nvarchar(100),
		PXNo char(10) foreign key references PhuongXa(maPX)
--Ràng buộc cho bảng NHANVIEN
alter table NHANVIEN
	drop column DIACHI
alter table NHANVIEN
	add soNhaTenDuong nvarchar(100),
		PXNo char(10) foreign key references PhuongXa(maPX),
		constraint CK_NHANVIEN_DIENTHOAI 
		check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
				or DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
--Ràng buộc cho bảng NHACUNGCAP
alter table NHACUNGCAP
	drop column DIACHI
alter table NHACUNGCAP
	add soNhaTenDuong nvarchar(100),
		PXNo char(10) foreign key references PhuongXa(maPX),
		constraint CK_NHACUNGCAP_DIENTHOAI 
		check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
				or DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
		constraint CK_NHACUNGCAP_EMAIL check (Email like '[a-z]%@%')
	