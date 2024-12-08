
ALTER DATABASE TCSDL2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
use master
drop database if exists TCSDL2
create database TCSDL2
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
		('KH002',N'Công ty TH ',N'giao dịch B',N'Nguyễn Lương Bằng','duong@gmail.com','0947530167','0896324345'),
		('KH003',N'Cong Ty DKC',	  N'giao dịch C',N'28 Lê Thanh Nghị', 'dkc@gmail.com',	'0896324344','0735682346'),
		('KH004',N'Công ty Vinfast',	  N'giao dịch D',N'Trưng Nữ Vương',	  'khd@gmail.com',	'0359838367','0983468945'),
		('KH005',N'Công ty ACECOOK ',  N'giao dịch E',N'51 Lê Đại Hành',   'gde@ggmail.com',	'0987324789','0385284633'),
		('KH006', N'Công ty ABC', N'Giao dịch F', N'10 Trần Phú', 'abc@domain.com', '0912345678', '0345678901'),
		('KH007', N'Công ty XYZ', N'Giao dịch G', N'20 Hoàng Diệu', 'xyz@domain.com', '0934567890', '0987654321'),
		('KH008', N'Công ty DEF', N'Giao dịch H', N'30 Lê Lợi', 'def@domain.com', '0954321987', '0356784321');

	--2.Nhập dữ liệu cho bảng NHANVIEN
set dateformat ymd
insert into NHANVIEN(MANHANVIEN,HO,TEN,NGAYSINH,NGAYLAMVIEC,DIACHI,DIENTHOAI,LUONGCOBAN,PHUCAP)
values  ('NV001',N'Nguyễn', N'Ly',		'2005-06-12',GETDATE(),	  N'12 Nghĩa Thắng','0983458945',5000000,100000),
		('NV002',N'Võ',		N'Quỳnh' ,	'1997-12-12','2024-05-01',N'Nghĩa Thuận',	'0832423367',40000000,800000),
		('NV003',N'Nguyễn',	N'Trường',	'2001-08-10','2022-02-14',N'Hai Bà Trưng',	'0984753434',10000000,500000),
		('NV004',N'Đoàn',	N'Quang',	'2000-06-05','2023-12-05',N'Ngô Tất Tố',	'0847350235',2000000,7000000),
		('NV005',N'Phan',	N'Anh',		'1990-11-15','2020-11-20',N'Quang Trung',	'0937320723',8000000,450000),
		('NV006', N'Phạm', N'Hùng', '1985-03-15', '2021-07-01', N'Số 45 Phan Đăng Lưu', '0962345678', 12000000, 800000),
		('NV007', N'Trần', N'Vy', '1992-01-25', '2023-02-20', N'Số 12 Lý Tự Trọng', '0976543210', 15000000, 600000),
		('NV008', N'Lê', N'Thành', '1988-11-10', '2020-09-05', N'Số 67 Bạch Đằng', '0923456789', 11000000, 900000);

	--3.Nhập dữ liệu cho bảng NHACUNGCAP
insert into NHACUNGCAP(MACONGTY,TENCONGTY,TENGIAODICH,DIACHI,DIENTHOAI,FAX,EMAIL)
values  ('NCC01',N'Công ty Vinamilk', N'Giao dịch A',N'Hùng Vương',		  '0389477645','0237938568','citi@gmail.com'),
		('NCC02',N'Công ty POCA',	  N'Giao dịch 2',N'Hải Phòng',		  '0983573952','0994239743','tesla@gmail.com'),
		('NCC03',N'Công ty Kaedehara',	  N'Giao dịch D',N'Nguyễn Hữu Thọ',	  '0823432452','0238493923','ama@gmail.com'),
		('NCC04',N'Công ty General Motors',  N'Giao dịch 4',N'Nguyễn Tri Phương','0475231234','0823478232','general@gmail.com'),
		('NCC05',N'Công ty VTP',	  N'Giao dịch 5',N'Võ Chí Công',      '0238493823','0823432453','pfi@gmail.com'),
		('NCC06', N'Công ty Phát Đạt', N'Giao dịch H', N'15 Đinh Tiên Hoàng', '0987654322', '0345678912', 'phatdat@gmail.com'),
		('NCC07', N'Công ty An Khang', N'Giao dịch I', N'25 Pasteur', '0913456789', '0387654321', 'ankhang@gmail.com'),
		('NCC08', N'Công ty Minh Long', N'Giao dịch J', N'35 Phạm Hùng', '0901234567', '0376543210', 'minhlong@gmail.com');

	--4.Nhập dữ liệu cho bảng LOAIHANG
insert into LOAIHANG(MALOAIHANG,TENLOAIHANG)
values  ('LH001',N'Hàng tiêu dùng'),
		('LH002',N'Hàng công nghiệp'),
		('LH003',N'Hàng hóa lâu dài'),
		('LH004',N'Hàng dược phẩm'),
		('LH005',N'Hàng thực phẩm');

	--5.Nhập dữ liệu cho bảng MATHANG
insert into MATHANG(MAHANG,TENHANG,SOLUONG,DONVITINH,GIAHANG,MACONGTY,MALOAIHANG)
values  ('MH001',N'Sữa tươi',49,N'thùng',350000,'NCC01','LH001'),
		('MH002',N'Sữa đậu nành đóng chai',50,	N'thùng',750000,'NCC01','LH001'),
		('MH003',N'Gạo',200,N'kg',25000,'NCC04','LH005'),
		('MH004',N'Vitamin D',40,N'vỉ',150000,	'NCC02','LH004'),
		('MH005',N'Thép',10,N'bao',	 50000,	'NCC03','LH002'),
		('MH006', N'Gạo lứt', 150, N'kg', 40000, 'NCC06', 'LH005'),
		('MH007', N'Đường tinh luyện', 200, N'thùng', 180000, 'NCC07', 'LH001'),
		('MH008', N'Khẩu trang y tế', 300, N'hộp', 75000, 'NCC08', 'LH004');

	--6.Nhập dữ liệu cho bảng DONDATHANG
set dateformat ymd
insert into DONDATHANG(SOHOADON,NGAYDATHANG,NGAYGIAOHANG,NGAYCHUYENHANG,MAKHACHHANG,MANHANVIEN,NOIGIAOHANG)
values  ('HD001','2022-12-12','2022-12-12', null,		'KH001','NV002',N'48 Cao Thắng'),
		('HD002','2022-11-15','2022-11-15','2022-11-16','KH004','NV001',null),
		('HD003','2023-08-20','2023-08-20', null,		'KH001','NV005',N'123 Âu Cơ'),
		('HD004','2022-06-24','2022-06-24','2023-06-25','KH002','NV002',null),
		('HD005',GETDATE()+2, GETDATE()+2,  GETDATE()+2,'KH005','NV001',N'Nguyễn Công Phương'),
		('HD006', '2023-02-15', '2023-02-20', '2023-02-22', 'KH006', 'NV007', N'15 Trần Hưng Đạo'),
		('HD007', '2023-03-01', '2023-03-03', '2023-03-05', 'KH007', 'NV008', N'30 Lý Thường Kiệt'),
		('HD008', '2023-04-10', '2023-04-15', NULL, 'KH008', 'NV006', N'5 Lê Văn Sỹ');
	--7.Nhập dữ liệu cho bảng CHITIETDATHANG
insert into CHITIETDATHANG(SOHOADON,MAHANG,GIABAN,SOLUONG,MUCGIAMGIA)
values  ('HD002','MH001',350000,5,default),
		('HD001','MH003',25000,	90,20),
		('HD003','MH004',15000,	10,5),
		('HD004','MH005',50000,	80,10),
		('HD005','MH001',350000,10,default),
		('HD006', 'MH006', 40000, 20, 0),
		('HD007', 'MH007', 180000, 5, 15),
		('HD008', 'MH008', 75000, 50, 10);


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
select * from MATHANG
select * from NHACUNGCAP
/* c) Cập nhật giá trị của trường NOIGIAOHANG trong bảng DONDATHANG 
		bằng địa chỉ của khách hàng đối với những đơn đặt hàng chưa xác định được nơi giao hàng 
		(giá trị trường NOIGIAOHANG bằng NULL).*/
update DONDATHANG 
set DONDATHANG.NOIGIAOHANG = kh.DIACHI
from KHACHHANG kh
where DONDATHANG.MAKHACHHANG= kh.MAKHACHHANG and DONDATHANG.NOIGIAOHANG is NULL

select * from DONDATHANG
select * from KHACHHANG

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

select * from KHACHHANG
select * from NHACUNGCAP


/* e)Tăng lương lên gấp rưỡi cho những nhân viên bán được số lượng hàng nhiều hơn 100 trong năm 2022.*/
update CHITIETDATHANG
set SOLUONG = 200
where MAHANG = 'MH003'
select * from CHITIETDATHANG

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

select * from NHANVIEN
select * from CHITIETDATHANG
select * from DONDATHANG

/* f) Tăng phụ cấp lên bằng 50% lương cho những nhân viên bán được hàng nhiều nhất.*/
update NHANVIEN
set PHUCAP = LUONGCOBAN * 0.5
where MANHANVIEN in(
			select top 1  nv.MANHANVIEN
			from NHANVIEN nv,CHITIETDATHANG ctdh,DONDATHANG ddh
			where nv.MANHANVIEN = ddh.MANHANVIEN
				and ddh.SOHOADON = ctdh.SOHOADON
			group by nv.MANHANVIEN 
			order by sum(ctdh.SOLUONG) desc);

select * from NHANVIEN
select * from CHITIETDATHANG
select * from DONDATHANG

/* g) Giảm 25% lương của những nhân viên trong năm 2023 không lập được bất kỳ đơn đặt hàng nào.*/
update NHANVIEN 
set LUONGCOBAN = LUONGCOBAN *0.75
where MANHANVIEN not in(
				select distinct nv.MANHANVIEN
				from DONDATHANG ddh,NHANVIEN nv
				where YEAR(ddh.NGAYDATHANG) = 2023
						and ddh.MANHANVIEN = nv.MANHANVIEN);

select * from NHANVIEN
select * from DONDATHANG

/* h) Giả sử trong bảng DONDATHANG có thêm trường SOTIEN 
		cho biết số tiền mà khách hàng phải trả trong mỗi đơn đặt hàng. 
		Hãy tính giá trị cho trường này.*/
select ddh.SOHOADON ,sum(GIABAN*SOLUONG - GIABAN*SOLUONG*MUCGIAMGIA/100) sotien
from DONDATHANG ddh, CHITIETDATHANG ctdh
where ddh.SOHOADON = ctdh.SOHOADON
group by ddh.SOHOADON

----------------------------BT cá nhân ----------------------------------

--1/cho biết danh sách các đối tác cung cấp 
select * from NHACUNGCAP

--2/cho biết mã và tên mặt hàng có giá lớn hơn 100000 và số lượng hiện có ít hơn 50
select * from MATHANG
select * from CHITIETDATHANG

update MATHANG
set SOLUONG = 50
where MAHANG = 'MH004';

select MAHANG, TENHANG
from MATHANG mh
where GIAHANG > 100000 and SOLUONG < 50

select distinct	m.maHang, m.TENHANG
from MATHANG m, CHITIETDATHANG c
where m.giaHang > 100000
	  and (m.soLuong - (SELECT SUM(c.soLuong) 
                   FROM CHITIETDATHANG c 
                   WHERE c.maHang = m.maHang))<50

--3/cho biết đơn số 1 do ai đặt, nhân viên nào lập, thời gian và địa điểm giao hàng ở đâu
select * from DONDATHANG
select * from NHANVIEN
select * from KHACHHANG

select TENCONGTY, CONCAT(HO,' ',TEN) as TenNhanVien, NGAYGIAOHANG, NOIGIAOHANG
from DONDATHANG ddh, KHACHHANG kh, NHANVIEN nv
where ddh.MANHANVIEN = nv.MANHANVIEN 
	and ddh.MAKHACHHANG = kh.MAKHACHHANG 
	and SOHOADON = 'HD001'

--4/Cho biết tên công ty, tên giao dịch, địa chỉ và điện thoại của các khách hàng và các nhà cung cấp hàng cho công ty

select *from KHACHHANG
select * from NHACUNGCAP

SELECT TENCONGTY, TENGIAODICH, DIACHI, DIENTHOAI 
FROM KHACHHANG
UNION
SELECT TENCONGTY, TENGIAODICH, DIACHI, DIENTHOAI 
FROM NHACUNGCAP;

--6/Hãy cho biết tổng số lượng hàng của mỗi mặt hàng mà công ty đã có (tổng số lượng hàng hiện có và đã bán)

select * from MATHANG
select * from CHITIETDATHANG

update CHITIETDATHANG
set SOLUONG = NULL
where MAHANG ='MH001'

SELECT MH.TENHANG, (MH.SOLUONG + SUM(COALESCE(CT.SOLUONG, 0))) AS TONG_SOLUONG --nếu số lượng là null sẽ hiển thị 0
FROM MATHANG MH, CHITIETDATHANG CT
WHERE CT.MAHANG = MH.MAHANG
GROUP BY MH.TENHANG, MH.SOLUONG
ORDER BY TONG_SOLUONG DESC;

SELECT 
    MAHANG, 
    TENHANG, 
    isnull((SELECT Sum(SOLUONG)  
				FROM CHITIETDATHANG 
				WHERE CHITIETDATHANG.MAHANG = MH.MAHANG
				GROUP BY MAHANG),0) sldb,
	SOLUONG sl_hienco,
	(SOLUONG +isnull ((select sum(SOLUONG) SL
						FROM CHITIETDATHANG CT
						WHERE CT.MAHANG=MH.MAHANG
						GROUP BY MAHANG),0)) TONG_SL
FROM MATHANG MH

-----------------------------------------------BÀI TẬP SELECT -----------------------------------------------

--câu 1
SELECT mh.MAHANG, mh.TENHANG, 
       (mh.SOLUONG - COALESCE(SUM(CHITIETDATHANG.SOLUONG), 0)) AS SOLUONG_HIEN_CO
FROM MATHANG mh
LEFT JOIN CHITIETDATHANG ON mh.MAHANG = CHITIETDATHANG.MAHANG
GROUP BY mh.MAHANG, mh.TENHANG, mh.SOLUONG;

--câu 2
select * from MATHANG
select * from NHACUNGCAP

SELECT MAHANG, TENHANG, TENCONGTY
FROM MATHANG
JOIN NHACUNGCAP ON MATHANG.MACONGTY = NHACUNGCAP.MACONGTY;

--câu 3

SELECT MANHANVIEN,CONCAT(HO,' ',TEN) as TenNhanVien , LUONGCOBAN + coalesce(PHUCAP,0) AS TONG_LUONG
FROM NHANVIEN;

--câu 4

select MAHANG,TENHANG
from MATHANG
where MAHANG in (select mh.MAHANG
	from MATHANG mh
	except 
	select ct.MAHANG
	from CHITIETDATHANG ct)


--câu 5

SELECT 
    KH.TENCONGTY AS TenCongTy,
    KH.TENGIAODICH AS TenGiaoDich,
    SUM(CT.GIABAN * CT.SOLUONG) AS TongChi
FROM 
    KHACHHANG KH
JOIN 
    DONDATHANG DH ON KH.MAKHACHHANG = DH.MAKHACHHANG
JOIN 
    CHITIETDATHANG CT ON DH.SOHOADON = CT.SOHOADON
GROUP BY 
    KH.MAKHACHHANG, KH.TENCONGTY, KH.TENGIAODICH
ORDER BY 
    TongChi DESC;

--câu 6

SELECT 
    MH.TENHANG AS TenHang,
    SUM(CT.GIABAN * CT.SOLUONG) AS TongDoanhThu
FROM 
    MATHANG MH
JOIN 
    CHITIETDATHANG CT ON MH.MAHANG = CT.MAHANG
JOIN 
    DONDATHANG DH ON CT.SOHOADON = DH.SOHOADON
WHERE 
    YEAR(DH.NGAYDATHANG) = 2022
GROUP BY 
    MH.MAHANG, MH.TENHANG
ORDER BY 
    TongDoanhThu DESC;


-------------------------------------------------Bài tập -----------------------------------------------
--câu 1
select TENCONGTY, concat(HO,' ',TEN) as TenKH
from KHACHHANG kh, NHANVIEN nv, DONDATHANG dh
where dh.MAKHACHHANG = kh.MAKHACHHANG 
	 and dh.MANHANVIEN = nv.MANHANVIEN
	 and SOHOADON = 'HD001'

--câu 2 trong công ti có bao nhiêu nhân viên cùng ngày sinh
select * 
from NHANVIEN
where NGAYSINH in (
	select NGAYSINH
	from NHANVIEN
	group by NGAYSINH
	having count(*) >1
	)
order by NGAYSINH;

--câu 4 hãy cho biết những nhân viên có lương cơ bản cao nhất
select * 
from NHANVIEN
where LUONGCOBAN = (	
	select MAX(LUONGCOBAN)
	from NHANVIEN
	);

--câu 3 những nhân viên chưa từng lập hóa đơn nào
select MANHANVIEN
from NHANVIEN
except
select MANHANVIEN
from DONDATHANG


--câu 5 loại hàng thực phẩm do những công ti nào cung cấp và địa chỉ công ti đó

select TENCONGTY, DIACHI
from NHACUNGCAP ncc
join
	MATHANG mh on mh.MACONGTY = ncc.MACONGTY
join 
	LOAIHANG lh on mh.MALOAIHANG = lh.MALOAIHANG
where TENLOAIHANG = N'Hàng thực phẩm'

--câu 6 mỗi nhân viên lập được bao nhiêu đơn hàng
SELECT NV.MANHANVIEN,concat(HO,' ',TEN) as HOTEN, COALESCE(COUNT(DD.SOHOADON), 0) AS SoLuongDonHang
FROM 
    NHANVIEN NV
LEFT JOIN 
    DONDATHANG DD ON NV.MANHANVIEN = DD.MANHANVIEN
GROUP BY 
    NV.MANHANVIEN, NV.HO, NV.TEN
ORDER BY 
    NV.MANHANVIEN;

--------------------------------------------Bài tập về hàm và thủ tục----------------
--câu 1 tạo thủ tục để lưu trữ thông tin thêm 1 bản ghi trong bảng MATHANG
CREATE PROCEDURE pr_MatHang_them 
    @maHang CHAR(5),
    @maCongty CHAR(5),
    @maLoaiHang CHAR(5),
    @tenHang NVARCHAR(100),
    @soLuong INT,
    @donViTinh NVARCHAR(50),
    @giaHang MONEY
AS 
BEGIN 
    IF NOT EXISTS 
       (SELECT 1 FROM MATHANG 
        WHERE MAHANG = @maHang)
		BEGIN
			INSERT INTO MATHANG 
			VALUES (@maHang, @tenHang, @soLuong, @donViTinh, @giaHang, @maCongty, @maLoaiHang);
        
			PRINT N'Dữ liệu đã được thêm thành công.';
		END
    ELSE
		BEGIN 
			PRINT N'Dữ liệu nhập vào không hợp lệ';
		END
END
EXEC pr_MatHang_them 
    @maHang = 'MH009', 
    @tenHang = N'Sản phẩm A', 
    @soLuong = 100, 
    @donViTinh = N'Chiếc', 
    @giaHang = 15000.00,
	@maCongty = 'NCC05', 
    @maLoaiHang = 'LH004';

select * from MATHANG