--drop database if exists TCSDL2
--create database TCSDL2
go
use TCSDL2
------------------------------------------------------TUẦN 5-----------------------------------------------------------------
create table KHACHHANG
(
	MAKHACHHANG char(5) primary key,
	TENCONGTY nvarchar(100),
	TENGIAODICH nvarchar(100) not null,
	DIACHI nvarchar(100),
	EMAIL varchar(50) unique,
	DIENTHOAI varchar(11) unique,
	FAX varchar(11) unique
)
create table NHANVIEN
(
	MANHANVIEN char(5) primary key,
	HO nvarchar(20) not null,
	TEN nvarchar(50)not null,
	NGAYSINH date,
	NGAYLAMVIEC datetime,
	DIACHI nvarchar(100),
	DIENTHOAI varchar(11) unique,
	LUONGCOBAN money
		check (LUONGCOBAN > 0),
	PHUCAP money
		check (PHUCAP>0)
)
create table LOAIHANG
(
	MALOAIHANG char(5) primary key,
	TENLOAIHANG nvarchar(100) not null
)
create table NHACUNGCAP
(
	 MACONGTY char(5) primary key,
	 TENCONGTY nvarchar(100) not null,
	 TENGIAODICH nvarchar(100),
	 DIACHI nvarchar(50),
	 DIENTHOAI varchar(11) unique,
	 FAX varchar(11) unique,
	 EMAIL varchar(50) unique
)
create table MATHANG
(
	MAHANG char(5) primary key,
	TENHANG nvarchar(100) not null,
	SOLUONG int
		check (SOLUONG>0),
	DONVITINH nvarchar(50)not null,
	GIAHANG money
		check (GIAHANG>0),
	MACONGTY char(5) foreign key references NHACUNGCAP(MACONGTY),
	MALOAIHANG char(5) foreign key references LOAIHANG(MALOAIHANG)
)
create table DONDATHANG
(
	SOHOADON char(5) primary key,
	NGAYDATHANG datetime,
	NGAYGIAOHANG datetime,
	NGAYCHUYENHANG datetime,
	NOIGIAOHANG nvarchar(100),
	MAKHACHHANG char(5) foreign key references KHACHHANG(MAKHACHHANG),
	MANHANVIEN char(5) foreign key references NHANVIEN(MANHANVIEN)
)

create table CHITIETDATHANG
(
	GIABAN money
		check (GIABAN>0),
	SOLUONG int
		check (SOLUONG>0),
	MUCGIAMGIA money
		check (MUCGIAMGIA>=0),
	primary key(SOHOADON,MAHANG),
	SOHOADON char(5) foreign key references DONDATHANG(SOHOADON),
	MAHANG char(5) foreign key references MATHANG(MAHANG)
)

------------------------------------------------------TUẦN 6----------------------------------------------------------

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
	add constraint CK_KHACHHANG_EMAIL check (Email like '[a-z]%@%'),
		constraint CK_KHACHHANG_DIENTHOAI
		check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
				or DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
		constraint CK_KHACHHANG_FAX
		check (FAX like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
				or FAX like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
--Ràng buộc cho bảng NHANVIEN
alter table NHANVIEN
	add constraint CK_NHANVIEN_DIENTHOAI 
		check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
				or DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
--Ràng buộc cho bảng NHACUNGCAP
alter table NHACUNGCAP
	add constraint CK_NHACUNGCAP_DIENTHOAI 
		check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
				or DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
		constraint CK_NHACUNGCAP_EMAIL check (Email like '[a-z]%@%'),
		constraint CK_NHACUNGCAP_FAX
		check (FAX like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
				or FAX like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
	
-------------------------------------------------TUẦN 7-------------------------------------------------------------------
--Nhập dữ liệu cho tất cả các bảng
	--1.Nhập dữ liệu cho bảng KHACHHANG
insert into KHACHHANG(MAKHACHHANG,TENCONGTY,TENGIAODICH,DIACHI,EMAIL,DIENTHOAI,FAX)
values  ('KH001',N'Công ty Vinamilk', N'giao dịch A',N'Hùng Vương',		  'kha@gmail.com',  '0987339356','0359838366'),
		('KH002',N'Công Ty Đại Dương',N'giao dịch B',N'Nguyễn Lương Bằng','duong@gmail.com','0947530167','0896324345'),
		('KH003',N'Cong Ty DKC',	  N'giao dịch C',N'28 Lê Thanh Nghị', 'dkc@gmail.com',	'0896324344','0735682346'),
		('KH004',N'Công ty Amazon',	  N'giao dịch D',N'Trưng Nữ Vương',	  'khd@gmail.com',	'0359838367','0983468945'),
		('KH005',N'Công ty Đại Nam',  N'giao dịch E',N'51 Lê Đại Hành',   'gde@ggmail.com',	'0987324789','0385284633');

	--2.Nhập dữ liệu cho bảng NHANVIEN
set dateformat ymd
insert into NHANVIEN(MANHANVIEN,HO,TEN,NGAYSINH,NGAYLAMVIEC,DIACHI,DIENTHOAI,LUONGCOBAN,PHUCAP)
values  ('NV001',N'Nguyễn', N'Ly',		'2005-06-12',GETDATE(),	  N'12 Nghĩa Thắng','0983458945',5000000,100000),
		('NV002',N'Võ',		N'Quỳnh' ,	'1997-12-12','2024-05-01',N'Nghĩa Thuận',	'0832423367',40000000,800000),
		('NV003',N'Nguyễn',	N'Trường',	'2001-08-10','2022-02-14',N'Hai Bà Trưng',	'0984753434',10000000,500000),
		('NV004',N'Đoàn',	N'Quang',	'2000-06-05','2023-12-05',N'Ngô Tất Tố',	'0847350235',2000000,7000000),
		('NV005',N'Phan',	N'Anh',		'1990-11-15','2020-11-20',N'Quang Trung',	'0937320723',8000000,450000);

	--3.Nhập dữ liệu cho bảng NHACUNGCAP
insert into NHACUNGCAP(MACONGTY,TENCONGTY,TENGIAODICH,DIACHI,DIENTHOAI,FAX,EMAIL)
values  ('NCC01',N'Công ty Vinamilk', N'Giao dịch A',N'Hùng Vương',		  '0389477645','0237938568','citi@gmail.com'),
		('NCC02',N'Công ty Tesla',	  N'Giao dịch 2',N'Hải Phòng',		  '0983573952','0994239743','tesla@gmail.com'),
		('NCC03',N'Công ty Amazon',	  N'Giao dịch D',N'Nguyễn Hữu Thọ',	  '0823432452','0238493923','ama@gmail.com'),
		('NCC04',N'Công ty General',  N'Giao dịch 4',N'Nguyễn Tri Phương','0475231234','0823478232','general@gmail.com'),
		('NCC05',N'Công ty Pfizer',	  N'Giao dịch 5',N'Võ Chí Công',      '0238493823','0823432453','pfi@gmail.com');

	--4.Nhập dữ liệu cho bảng LOAIHANG
insert into LOAIHANG(MALOAIHANG,TENLOAIHANG)
values  ('LH001',N'Hàng tiêu dùng'),
		('LH002',N'Hàng công nghiệp'),
		('LH003',N'Hàng hóa lâu dài'),
		('LH004',N'Hàng dược phẩm'),
		('LH005',N'Hàng nông sản');

	--5.Nhập dữ liệu cho bảng MATHANG
insert into MATHANG(MAHANG,TENHANG,SOLUONG,DONVITINH,GIAHANG,MACONGTY,MALOAIHANG)
values  ('MH001',N'Sữa tươi',			100,N'thùng',350000,'NCC01','LH001'),
		('MH002',N'Nước uống đóng chai',50,	N'thùng',750000,'NCC01','LH001'),
		('MH003',N'Lúa',				200,N'kg',	 25000,	'NCC04','LH005'),
		('MH004',N'Vitamin C',			40,	N'vỉ',	 15000,	'NCC02','LH004'),
		('MH005',N'Xi măng',			10,	N'bao',	 50000,	'NCC03','LH002');
	--6.Nhập dữ liệu cho bảng DONDATHANG
set dateformat ymd
insert into DONDATHANG(SOHOADON,NGAYDATHANG,NGAYGIAOHANG,NGAYCHUYENHANG,MAKHACHHANG,MANHANVIEN,NOIGIAOHANG)
values  ('HD001','2022-12-12','2022-12-12', null,		'KH001','NV002',null),
		('HD002','2022-11-15','2022-11-15','2022-11-16','KH004','NV001',null),
		('HD003','2023-08-20','2023-08-20', null,		'KH001','NV005',N'123 Âu Cơ'),
		('HD004','2022-06-24','2022-06-24','2023-06-25','KH002','NV002',null),
		('HD005',GETDATE()+2, GETDATE()+2,  GETDATE()+2,'KH005','NV001',N'Nguyễn Công Phương');
	--7.Nhập dữ liệu cho bảng CHITIETDATHANG
insert into CHITIETDATHANG(SOHOADON,MAHANG,GIABAN,SOLUONG,MUCGIAMGIA)
values  ('HD002','MH001',350000,5,default),
		('HD001','MH003',25000,	90,20),
		('HD003','MH004',15000,	10,5),
		('HD004','MH005',50000,	80,10),
		('HD005','MH001',350000,10,default);


-------------------------------------------------TUẦN 8-------------------------------------------------------------------

/*  a) Cập nhật lại giá trị trường NGAYCHUYENHANG của những bản ghi có NGAYCHUYENHANG chưa xác định (NULL) 
trong bảng DONDATHANG bằng với giá trị của trường NGAYDATHANG.*/

update DONDATHANG
set NGAYCHUYENHANG = NGAYDATHANG
where NGAYCHUYENHANG is NULL
/* b)Tăng số lượng hàng của những mặt hàng do công ty VINAMILK cung cấp lên gấp đôi.*/
update MATHANG 
set SOLUONG = SOLUONG *2
where MACONGTY in(
		select MACONGTY
		from NHACUNGCAP
		where TENCONGTY = N'Công ty Vinamilk');

/* c) Cập nhật giá trị của trường NOIGIAOHANG trong bảng DONDATHANG 
		bằng địa chỉ của khách hàng đối với những đơn đặt hàng chưa xác định được nơi giao hàng 
		(giá trị trường NOIGIAOHANG bằng NULL).*/
update DONDATHANG 
set DONDATHANG.NOIGIAOHANG = kh.DIACHI
from KHACHHANG kh
where DONDATHANG.MAKHACHHANG= kh.MAKHACHHANG and DONDATHANG.NOIGIAOHANG is NULL

/*d) Cập nhật lại dữ liệu trong bảng KHACHHANG 
	sao cho nếu tên công ty và tên giao dịch của khách hàng 
	trùng với tên công ty và tên giao dịch của một nhà cung cấp nào đó 
	thì địa chỉ, điện thoại, fax và e-mail phải giống nhau.*/

UPDATE KHACHHANG
SET DIACHI = (SELECT DIACHI 
              FROM NHACUNGCAP ncc
              WHERE ncc.TENCONGTY = KHACHHANG.TENCONGTY 
              AND ncc.TENGIAODICH = KHACHHANG.TENGIAODICH),
    DIENTHOAI = (SELECT DIENTHOAI 
                 FROM NHACUNGCAP ncc
                 WHERE ncc.TENCONGTY = KHACHHANG.TENCONGTY 
                 AND ncc.TENGIAODICH = KHACHHANG.TENGIAODICH),
    FAX = (SELECT FAX 
           FROM NHACUNGCAP ncc
           WHERE ncc.TENCONGTY = KHACHHANG.TENCONGTY 
           AND ncc.TENGIAODICH = KHACHHANG.TENGIAODICH),
    EMAIL = (SELECT EMAIL 
             FROM NHACUNGCAP ncc 
             WHERE ncc.TENCONGTY = KHACHHANG.TENCONGTY 
             AND ncc.TENGIAODICH = KHACHHANG.TENGIAODICH)
WHERE EXISTS (SELECT 1 
              FROM NHACUNGCAP ncc
              WHERE ncc.TENCONGTY = KHACHHANG.TENCONGTY 
              AND ncc.TENGIAODICH = KHACHHANG.TENGIAODICH);

/* e)Tăng lương lên gấp rưỡi cho những nhân viên bán được số lượng hàng nhiều hơn 100 trong năm 2022.*/
update NHANVIEN
set LUONGCOBAN = LUONGCOBAN *1.5
where MANHANVIEN in (
			select nv.MANHANVIEN
			from CHITIETDATHANG ctdh,NHANVIEN nv,DONDATHANG ddh
			where nv.MANHANVIEN = ddh.MANHANVIEN
				and ddh.SOHOADON = ctdh.SOHOADON
				and YEAR(ddh.NGAYDATHANG) = 2022
			group by nv.MANHANVIEN
			having sum(ctdh.SOLUONG) >100);

/* f) Tăng phụ cấp lên bằng 50% lương cho những nhân viên bán được hàng nhiều nhất.*/
update NHANVIEN
set PHUCAP = LUONGCOBAN * 0.5
where MANHANVIEN in(
			select top 3  nv.MANHANVIEN
			from NHANVIEN nv,CHITIETDATHANG ctdh,DONDATHANG ddh
			where nv.MANHANVIEN = ddh.MANHANVIEN
				and ddh.SOHOADON = ctdh.SOHOADON
			group by nv.MANHANVIEN 
			order by sum(ctdh.SOLUONG) desc);

/* g) Giảm 25% lương của những nhân viên trong năm 2023 không lập được bất kỳ đơn đặt hàng nào.*/
update NHANVIEN 
set LUONGCOBAN = LUONGCOBAN *0.75
where MANHANVIEN not in(
				select distinct nv.MANHANVIEN
				from DONDATHANG ddh,NHANVIEN nv
				where YEAR(ddh.NGAYDATHANG) = 2023
						and ddh.MANHANVIEN = nv.MANHANVIEN);

/* h) Giả sử trong bảng DONDATHANG có thêm trường SOTIEN 
		cho biết số tiền mà khách hàng phải trả trong mỗi đơn đặt hàng. 
		Hãy tính giá trị cho trường này.*/
select ddh.SOHOADON ,sum(GIABAN*SOLUONG - GIABAN*SOLUONG*MUCGIAMGIA/100) sotien
from DONDATHANG ddh, CHITIETDATHANG ctdh
where ddh.SOHOADON = ctdh.SOHOADON
group by ddh.SOHOADON






