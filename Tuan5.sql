create table KHACHHANG (
	MAKHACHHANG char(10) not null unique,
	TENCONGTY nvarchar(50) not null,
	TENGIAODICH nvarchar(50) not null,
	DIACHI nvarchar(50),
	EMAIL varchar(15) not null unique,
	DIENTHOAI varchar(15) not null unique,
	FAX nvarchar(50),
	primary key (MAKHACHHANG),
);
GO
 
create table CHITIETDATHANG (
	SOHOADON char(10) not null unique,
	MAHANG char(10) not null unique,
	GIABAN varchar(50) not null,
	SOLUONG varchar(50) not null,
	MUCGIAMGIA varchar(50),
	primary key (SOHOADON),
);
go