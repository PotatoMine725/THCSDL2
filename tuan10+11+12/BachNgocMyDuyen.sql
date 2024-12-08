--drop database if exists BachNgocMyDuyen
--create database BachNgocMyDuyen
go
use BachNgocMyDuyen
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
		('NV002',N'Võ',		N'Quỳnh' ,	'1997-12-06','2024-05-01',N'Nghĩa Thuận',	'0832423367',40000000,800000),
		('NV003',N'Nguyễn',	N'Trường',	'2001-06-24','2022-02-14',N'Hai Bà Trưng',	'0984753434',10000000,500000),
		('NV004',N'Đoàn',	N'Quang',	'2005-06-12','2023-12-05',N'Ngô Tất Tố',	'0847350235',2000000,7000000),
		('NV005',N'Phan',	N'Anh',		'1990-11-15','2020-11-20',N'Quang Trung',	'0937320723',8000000,450000);

	--3.Nhập dữ liệu cho bảng NHACUNGCAP
insert into NHACUNGCAP(MACONGTY,TENCONGTY,TENGIAODICH,DIACHI,DIENTHOAI,FAX,EMAIL)
values  ('NCC01',N'Công ty Vinamilk', N'Giao dịch A', N'Hùng Vương',	  '0389477645','0237938568','citi@gmail.com'),
		('NCC02',N'Công ty Tesla',	  N'Giao dịch A2',N'Hải Phòng',		  '0983573952','0994239743','tesla@gmail.com'),
		('NCC03',N'Công ty Amazon',	  N'Giao dịch D', N'Nguyễn Hữu Thọ',  '0823432452','0238493923','ama@gmail.com'),
		('NCC04',N'Công ty General',  N'Giao dịch A4',N'Nguyễn Tri Phương','0475231234','0823478232','general@gmail.com'),
		('NCC05',N'Công ty Pfizer',	  N'Giao dịch A5',N'Võ Chí Công',      '0238493823','0823432453','pfi@gmail.com');

	--4.Nhập dữ liệu cho bảng LOAIHANG
insert into LOAIHANG(MALOAIHANG,TENLOAIHANG)
values  ('LH001',N'Hàng thực phẩm'),
		('LH002',N'Hàng công nghiệp'),
		('LH003',N'Hàng hóa lâu dài'),
		('LH004',N'Hàng dược phẩm'),
		('LH005',N'Hàng nông sản');

	--5.Nhập dữ liệu cho bảng MATHANG
insert into MATHANG(MAHANG,TENHANG,SOLUONG,DONVITINH,GIAHANG,MACONGTY,MALOAIHANG)
values  ('MH001',N'Sữa tươi',			100,N'thùng',350000,'NCC01','LH001'),
		('MH002',N'Nước uống đóng chai',30,	N'thùng',75000, 'NCC01','LH001'),
		('MH003',N'Lúa',				200,N'kg',	 25000,	'NCC04','LH005'),
		('MH004',N'Vitamin C',			40,	N'vỉ',	 150000,'NCC02','LH004'),
		('MH005',N'Xi măng',			10,	N'bao',	 100000, 'NCC03','LH002');
	--6.Nhập dữ liệu cho bảng DONDATHANG
set dateformat ymd
insert into DONDATHANG(SOHOADON,NGAYDATHANG,NGAYGIAOHANG,NGAYCHUYENHANG,MAKHACHHANG,MANHANVIEN,NOIGIAOHANG)
values  ('HD001','2022-12-12','2022-12-12','2022-12-12','KH001','NV002',N'Trần Cao vân'),
		('HD002','2022-11-15','2022-11-15','2022-11-15','KH004','NV001',null),
		('HD003','2023-08-20','2023-08-20', null,		'KH001','NV005',N'123 Âu Cơ'),
		('HD004','2022-06-24','2022-06-24','2023-06-24','KH002','NV002',null),
		('HD005',GETDATE()+2, GETDATE()+2,  null,		'KH005','NV001',N'Nguyễn Công Phương');
	--7.Nhập dữ liệu cho bảng CHITIETDATHANG
insert into CHITIETDATHANG(SOHOADON,MAHANG,GIABAN,SOLUONG,MUCGIAMGIA)
values  ('HD002','MH001',400000,5,default),
		('HD001','MH003',29000,	90,10),
		('HD003','MH004',20000,	10,5),
		('HD004','MH005',110000,80,3),
		('HD005','MH001',370000,10,default);


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
set PHUCAP = LUONGCOBAN * 1.5
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

-------------------------------------------BÀI TẬP CÁ NHÂN-------------------------------------------------------------
		
		/*Sử dụng câu lệnh SELECT để viết các yêu cầu truy vấn dữ liệu sau đây:*/

--1.Cho biết danh sách các đối tác cung cấp hàng cho công ty
select *
from NhaCungCap

--2.Cho biết mã và tên của các mặt hàng có giá lớn hơn 100000 và số lượng hiện có ít hơn 50.
select MAHANG,TENHANG
from MATHANG
where (GIAHANG >100000) and (SOLUONG <50)

--3.Đơn đặt hàng số 1 do ai đặt và do nhân viên nào lập, thời gian và địa điểm giao hàng là ở đâu?
	--cách 1:
select ddh.MAKHACHHANG, kh.TENCONGTY, nv.HO +' '+nv.TEN as NhanVien, ddh.NGAYGIAOHANG, ddh.NOIGIAOHANG
from DONDATHANG ddh,KHACHHANG kh,NHANVIEN nv
where ddh.SOHOADON ='HD001' 
		and ddh.MAKHACHHANG = kh.MAKHACHHANG
		and ddh.MANHANVIEN = nv.MANHANVIEN

	--cách 2:
SELECT dondathang.manhanvien,ho,ten, ngaygiaohang,noigiaohang 
 FROM nhanvien INNER JOIN dondathang  
  ON nhanvien.manhanvien=dondathang.manhanvien 
 WHERE sohoadon='HD001'

--4.Cho biết tên công ty, tên giao dịch, địa chỉ và điện thoại của các khách hàng và các nhà cung cấp hàng cho công ty.
select TENCONGTY,TENGIAODICH,DIACHI,DIENTHOAI
from KHACHHANG
union 
select TENCONGTY,TENGIAODICH,DIACHI,DIENTHOAI
from NHACUNGCAP

--5.Cho biết tên công ty, tên giao dịch, địa chỉ và điện thoại của các khách hàng và các nhà cung cấp hàng cho công ty.
select TENCONGTY,TENGIAODICH,DIACHI,DIENTHOAI
from KHACHHANG kh
union all
select TENCONGTY,TENGIAODICH,DIACHI,DIENTHOAI
from NHACUNGCAP ncc

--6.Hãy cho biết tổng số lượng hàng của mỗi mặt hàng mà công ty đã có (tổng số lượng hàng hiện có và đã bán)
--cách 1:
select sub.TENHANG, sum(sub.SOLUONG) as tongsl
from ( 
	select TENHANG,SOLUONG
	from MATHANG 
	union all
	select mh.TENHANG,ctdh.SOLUONG
	from CHITIETDATHANG ctdh,MATHANG mh
	where ctdh.MAHANG = mh.MAHANG
)as sub
group by sub.TENHANG
--cách 2:
SELECT mathang.mahang,tenhang, 
 	    mathang.soluong +  
   	 CASE  
WHEN SUM(chitietdathang.soluong) IS NULL THEN 0 
	 ELSE SUM(chitietdathang.soluong) 
 	 	  END AS tongsoluong    
FROM mathang LEFT OUTER JOIN chitietdathang 
		ON mathang.mahang=chitietdathang.mahang 
 GROUP BY mathang.mahang,tenhang,mathang.soluong
--cách 3:
select	MAHANG,
		TENHANG,
		coalesce(sum(SOLUONG), 0) + coalesce((select sum(SOLUONG)
											 from CHITIETDATHANG ctdh
											 where ctdh.MAHANG = mh.MAHANG),0) as TONG_SOLUONG 
from MATHANG mh
group by mh.MAHANG, mh.TENHANG;


----------------------------------------------TUẦN 10---------------------------------------------------------------------
	/*1. Mã hàng, tên hàng và số lượng của các mặt hàng hiện có trong công ty*/
select MAHANG,TENHANG, SOLUONG
from MATHANG 

	/*2. Cho biết mỗi mặt hàng trong công ty do ai cung cấp*/
select mh.MAHANG,mh.TENHANG,ncc.TENCONGTY
from MATHANG mh, NHACUNGCAP ncc
where mh.MACONGTY = ncc.MACONGTY

	/*3. Hãy cho biết số tiền lương mà công ty phải trả cho mỗi nhân viên là bao nhiêu
			(luong = luongcoban + phucap )*/
select MANHANVIEN, HO + ' '+TEN as hotenNV, format((lUONGCOBAN +coalesce(PHUCAP, 0)),'##,#\ VND','es-ES') as luong
from NHANVIEN

	/*4. Những mặt hàng nào chưa từng được khách hàng đặt mua */
select MAHANG
from MATHANG
except
select MAHANG
from CHITIETDATHANG

select MAHANG,TENHANG
from MATHANG
where MAHANG in (select mh.MAHANG
	from MATHANG mh
	except 
	select ct.MAHANG
	from CHITIETDATHANG ct)

	/*5. Hãy cho biết mỗi một khách hàng đã phải bỏ ra bao nhiêu tiền để đặt mua hàng của công ty*/
select kh.MAKHACHHANG, kh.TENCONGTY,
	format(sum(ctdh.GIABAN*coalesce(ctdh.SOLUONG,0) - ctdh.GIABAN*coalesce(ctdh.SOLUONG,0)*coalesce((ctdh.MUCGIAMGIA/100),0)),'##,#\ VND','es-ES') as tongtien
from KHACHHANG kh, DONDATHANG ddh, CHITIETDATHANG ctdh
where kh.MAKHACHHANG = ddh.MAKHACHHANG
	and ddh.SOHOADON = ctdh.SOHOADON
group by kh.MAKHACHHANG,kh.TENCONGTY


	/*6. Hãy cho biết tổng số tiền lời mà công ty thu được từ mỗi mặt hàng trong năm 2022*/
select mh.MAHANG,mh.TENHANG,
	format(sum(ctdh.GIABAN*coalesce(ctdh.SOLUONG,0) - ctdh.GIABAN*coalesce(ctdh.SOLUONG,0)*coalesce((ctdh.MUCGIAMGIA/100),0) - mh.GIAHANG*coalesce(ctdh.SOLUONG,0)),'##,#\ VND','es-ES') as tienLoi
from MATHANG mh,CHITIETDATHANG ctdh,DONDATHANG ddh
where YEAR(ddh.NGAYDATHANG)='2022'
	and mh.MAHANG=ctdh.MAHANG
	and ctdh.SOHOADON=ddh.SOHOADON
group by mh.MAHANG,mh.TENHANG


-------------------------------------------------TUẦN 11-------------------------------------------------------------------------
	/* 1. Đơn đặt hàng số 1 do ai đặt và do nhân viên nào lập,thời gian và địa điểm giao hàng là ở đâu */
select dondathang.manhanvien,ho,ten, ngaygiaohang,noigiaohang 
from nhanvien INNER JOIN dondathang  
on nhanvien.manhanvien=dondathang.manhanvien 
where sohoadon='HD001'

	/* 2. Trong công ty có những nhân viên nào có cùng ngày sinh */
select n.NGAYSINH, COUNT(*) as 'Số lượng', string_agg(HO + ' '+ TEN, ', ') as 'Họ và tên'  --string_agg: tổng hợp các giá trị từ nhiều hàng thành một chuỗi duy nhất
from NHANVIEN n
group by NGAYSINH
having COUNT(*) > 1;

	/* 3. Những nhân viên nào của công ty chưa từng lập bất kỳ một hóa đơn đặt hàng nào? */
select MANHANVIEN
from NHANVIEN
except
select MANHANVIEN
from DONDATHANG

	/* 4. Những nhân viên nào của công ty có lương cơ bản cao nhất? */
SELECT HO + ' ' + TEN AS TenNhanVien, LUONGCOBAN 
FROM NHANVIEN
WHERE LUONGCOBAN = (SELECT MAX(LUONGCOBAN) FROM NHANVIEN);

	/* 5. Loại hàng thực phẩm do những công ty nào cung cấp và địa chỉ của các công ty đó là gì? */
select distinct TENCONGTY, DIACHI
from NHACUNGCAP ncc
join
	MATHANG mh on mh.MACONGTY = ncc.MACONGTY
join 
	LOAIHANG lh on mh.MALOAIHANG = lh.MALOAIHANG
where TENLOAIHANG = N'Hàng thực phẩm'

	/* 6. Mỗi một nhân viên của công ty đã lập bao nhiêu đơn đặt hàng 
		(nếu nhân viên chưa hề lập một hóa đơn nào thì cho kết quả là 0) */
select nv.MANHANVIEN, HO + ' '+TEN as hoten,coalesce(count(SOHOADON),0) as sohoadon
from NHANVIEN nv left join DONDATHANG ddh
on nv.MANHANVIEN=ddh.MANHANVIEN
group by nv.MANHANVIEN, HO + ' '+TEN
go
-------------------------------------------------TUẦN 12---------------------------------------------------------------------------------

	/* 1.Tạo thủ tục lưu trữ để thông qua thủ tục này có thể bổ sung thêm một bản ghi mới cho bảng mathang 
	(thủ tục phải thực hiện kiểm tra tính hợp lệ của dữ liệu cần bổ sung: không trùng khóa chính và đảm bảo toàn vẹn tham chiếu)*/
drop proc if exists pr_bsMatHang;
go
create proc pr_bsMatHang
    @maHang char(5),
    @tenHang nvarchar(100),
    @maCongTy char(5),
    @maLoaiHang char(5),
    @soLuong int,
    @donViTinh nvarchar(50),
    @giaHang money
as
begin
    set nocount on;

    -- Kiểm tra nếu mã hàng đã tồn tại
    if exists (select 1 from MATHANG where MAHANG = @maHang)
    begin
        print @maHang + N' đã tồn tại trong bảng MATHANG';
        return;
    end

    -- Kiểm tra nếu mã hàng không hợp lệ
    if @maHang not like 'MH%'
    begin
        print N'Mã hàng không hợp lệ';
        return;
    end

    -- Kiểm tra nếu mã công ty không tồn tại
    if not exists (select 1 from NHACUNGCAP where MACONGTY = @maCongTy)
    begin
        print N'MACONGTY = ' + CAST(@maCongTy AS NVARCHAR) + N' không có trong bảng NHACUNGCAP';
        return;
    end

    -- Kiểm tra nếu mã loại hàng không tồn tại
    if not exists (select 1 from LOAIHANG where MALOAIHANG = @maLoaiHang)
    begin
        print N'MALOAIHANG = ' + CAST(@maLoaiHang AS NVARCHAR) + N' không có trong bảng LOAIHANG';
        return;
    end

    -- Thêm bản ghi mới
	insert into MATHANG(MAHANG,TENHANG,SOLUONG,DONVITINH,GIAHANG,MACONGTY,MALOAIHANG)
	values (@maHang, @tenHang,@soLuong,@donViTinh,@giaHang,@maCongTy,@maLoaiHang);
end
go
exec pr_bsMatHang 
		@maHang='MH006', 
		@tenHang= N'Nước yến',
		@soLuong= 250,
		@donViTinh= N'thùng', 
		@giaHang=70000,
		@maCongTy= 'NCC01',
		@maLoaiHang= 'LH001';
select *
from MATHANG

	/* 2.Tạo thủ tục lưu trữ có chức năng thống kê tổng số lượng hàng bán được của một mặt hàng có mã bất kỳ 
	(mã mặt hàng cần thống kê là tham số của thủ tục)*/
drop proc if exists pr_thongKeTongSoLuongHang
go
create proc pr_thongKeTongSoLuongHang
	@maHang char(5)
as
begin 
	select m.MAHANG, m.TENHANG, isnull ((select sum(c.SOLUONG)
								         from CHITIETDATHANG c
										 where c.MAHANG = m.MAHANG
								         group by c.MAHANG),0) as tongSoLuongBanRa
	from MATHANG m
	where m.MAHANG = @maHang
end
go
exec pr_thongKeTongSoLuongHang 'MH001';

	/* 3.Viết hàm trả về một bảng trong đó cho biết tổng số lượng hàng bán được của mỗi mặt hàng. 
	Sử dụng hàm này để thống kê xem tổng số lượng hàng (hiện có và đã bán) của mỗi mặt hàng là bao nhiêu*/
IF OBJECT_ID('fn_tongSoLuongHangCuaMoiMatHang', 'IF') IS NOT NULL
    DROP FUNCTION fn_tongSoLuongHangCuaMoiMatHang;
GO

-- Tạo lại hàm
CREATE FUNCTION fn_tongSoLuongHangCuaMoiMatHang()
RETURNS TABLE
AS
RETURN (
    SELECT
        m.MAHANG, 
        m.TENHANG, 
        ISNULL(SUM(c.SOLUONG), 0) AS tongSoLuongBanRa
    FROM MATHANG m
    LEFT JOIN CHITIETDATHANG c
        ON m.MAHANG = c.MAHANG
    GROUP BY m.MAHANG, m.TENHANG
);
GO

-- Gọi hàm để kiểm tra kết quả
SELECT * FROM fn_tongSoLuongHangCuaMoiMatHang();
go

--Tạo hàm thống kê tổng số lượng hàng (hiện có và đã bán) của mỗi mặt hàng
-- Xóa hàm nếu đã tồn tại
IF OBJECT_ID('fn_thongKeSoLuongHang', 'IF') IS NOT NULL
    DROP FUNCTION fn_thongKeSoLuongHang;
GO
-- Tạo lại hàm
CREATE FUNCTION fn_thongKeSoLuongHang()
RETURNS TABLE
AS
RETURN (
    SELECT 
        m.MAHANG, 
        m.TENHANG, 
        CASE 
            WHEN (m.SOLUONG - ISNULL(fn.tongSoLuongBanRa, 0)) < 0 THEN 0 
            ELSE (m.SOLUONG - ISNULL(fn.tongSoLuongBanRa, 0)) 
        END AS soLuongHangHienCo, 
        ISNULL(fn.tongSoLuongBanRa, 0) AS tongSoLuongBanRa, 
        m.DONVITINH
    FROM 
        MATHANG m
    LEFT JOIN 
        fn_tongSoLuongHangCuaMoiMatHang() fn
    ON 
        m.MAHANG = fn.MAHANG
);
GO
-- Gọi hàm để kiểm tra kết quả
SELECT * FROM fn_thongKeSoLuongHang();
go

	/* 4.Viết trigger cho bảng CHITIETDATHANG theo yêu cầu sau:
		- Khi một bản ghi mới được bổ sung vào bảng này thì giảm số lượng hàng hiện có 
			nếu số lượng hàng hiện có lớn hơn hoặc bằng số lượng hàng được bán ra. 
			Ngược lại thì hủy bỏ thao tác bổ sung
		- Khi cập nhật lại số lượng hàng được bán, kiểm tra số lượng hàng được cập nhật lại có phù hợp hay không
			(số lượng hàng bán ra không được vượt quá số lượng hàng hiện có và không được nhỏ hơn 1).
			Nếu dữ liệu hợp lệ thì giảm (hoặc tăng) số lượng hàng hiện có trong công ty, ngược lại thì hủy bỏ thao tác cập nhật*/
CREATE TRIGGER trg_CHITIETDATHANG
ON CHITIETDATHANG
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Xử lý cho thao tác INSERT
    IF EXISTS (SELECT 1 FROM inserted WHERE NOT EXISTS (SELECT 1 FROM deleted))
    BEGIN
        -- Kiểm tra số lượng hàng hiện có đủ để bán
        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN MATHANG m ON i.MAHANG = m.MAHANG
            WHERE m.SOLUONG < i.SOLUONG OR i.SOLUONG < 1
        )
        BEGIN
            -- Hủy thao tác nếu số lượng không hợp lệ
            ROLLBACK TRANSACTION;
            PRINT N'Hủy thao tác INSERT: Số lượng hàng không đủ hoặc không hợp lệ.';
            RETURN;
        END

        -- Giảm số lượng hàng hiện có
        UPDATE MATHANG
        SET SOLUONG = m.SOLUONG - i.SOLUONG
        FROM MATHANG m
        JOIN inserted i ON m.MAHANG = i.MAHANG;

        PRINT N'Thêm mới thành công: Số lượng hàng đã được cập nhật.';
    END

    -- Xử lý cho thao tác UPDATE
    IF EXISTS (SELECT 1 FROM inserted JOIN deleted ON inserted.SOHOADON = deleted.SOHOADON AND inserted.MAHANG = deleted.MAHANG)
    BEGIN
        -- Kiểm tra tính hợp lệ của số lượng hàng cập nhật
        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN deleted d ON i.SOHOADON = d.SOHOADON AND i.MAHANG = d.MAHANG
            JOIN MATHANG m ON i.MAHANG = m.MAHANG
            WHERE i.SOLUONG < 1 OR m.SOLUONG + d.SOLUONG - i.SOLUONG < 0
        )
        BEGIN
            -- Hủy thao tác nếu số lượng không hợp lệ
            ROLLBACK TRANSACTION;
            PRINT N'Hủy thao tác UPDATE: Số lượng hàng cập nhật không hợp lệ.';
            RETURN;
        END

        -- Cập nhật số lượng hàng hiện có
        UPDATE MATHANG
        SET SOLUONG = m.SOLUONG + d.SOLUONG - i.SOLUONG
        FROM MATHANG m
        JOIN inserted i ON m.MAHANG = i.MAHANG
        JOIN deleted d ON i.SOHOADON = d.SOHOADON AND i.MAHANG = d.MAHANG;

        PRINT N'Cập nhật thành công: Số lượng hàng đã được điều chỉnh.';
    END
END;
GO

UPDATE CHITIETDATHANG
SET SOLUONG = 5
WHERE SOHOADON = 'HD001' AND MAHANG = 'MH003';

