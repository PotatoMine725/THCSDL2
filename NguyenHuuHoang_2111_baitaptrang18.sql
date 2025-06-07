--USE master;
--GO
--ALTER DATABASE QLBH_2111 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--GO

DROP DATABASE IF EXISTS QLBH_2111;

CREATE DATABASE QLBH_2111;
GO

USE QLBH_2111;
GO

-- tạo bảng khách hàng 
CREATE TABLE KhachHang (
    maKH char(6) PRIMARY KEY not null,
    tenKH nvarchar(50) not null,
    diaChiKH nvarchar(100) not null,
    SDT varchar(11) not null,
    Email varchar(30),
    soDuTaiKhoan money,
    CHECK (soDuTaiKhoan >= 0)
);

-- tạo bảng nhân viên
CREATE TABLE NhanVien (
    maNV char(5) PRIMARY KEY not null,
    tenNV nvarchar(50) not null,
    SDT varchar(11) not null,
    Email varchar(50),
    gioiTinh nvarchar(4),
    DoB Date not null,
    Salary money not null
);

--tạo bảng DonDatHang_HoaDon 
CREATE TABLE DonDatHang_HoaDon (
    maDH char(6) PRIMARY KEY not null,
    maKH char(6) not null,
    maNV char(5) not null,
    ngayTaoDH date not null,
    diaChiGiaoHang nvarchar(100) not null,
    SDTGiaoHang varchar(11) not null,
    maHDDienTu char(8) not null,
    ngayThanhToan date,
    ngayGiaoHang date,
    trangThaiDH nvarchar(30) not null,
    FOREIGN KEY (maKH) REFERENCES KhachHang(maKH),
    FOREIGN KEY (maNV) REFERENCES NhanVien(maNV)
);

--tạo bảng NhaCungCap 
CREATE TABLE NhaCungCap (
    maNCC char(6) PRIMARY KEY not null,
    tenNCC nvarchar(50) not null,
    diaChiNCC nvarchar(100) not null,
    SDT varchar(11) not null,
    nhanVienLienHe nvarchar(50)
);

--tạo bảng PhieuNhap 
CREATE TABLE PhieuNhap (
    maPN char(7) PRIMARY KEY not null,
    maNCC char(6) not null,
    ngayNhapHang date not null,
    FOREIGN KEY (maNCC) REFERENCES NhaCungCap(maNCC)
);

-- tạo bảng SanPham 
CREATE TABLE SanPham (
    maSP char(7) PRIMARY KEY not null,
    tenSP nvarchar(50),
    donGia money,
    soLuongCon bigint,
    soLuongCanDuoi smallint
);

--tạo bảng ChiTietPhieuNhap
CREATE TABLE ChiTietPhieuNhap (
    maPN char(7) not null,
    maSP char(7) not null,
    soLuongNhap int,
    giaNhap money,
    PRIMARY KEY (maPN, maSP),
    FOREIGN KEY (maPN) REFERENCES PhieuNhap(maPN),
    FOREIGN KEY (maSP) REFERENCES SanPham(maSP)
);

--tạo bảng ChiTietDonHang
CREATE TABLE ChiTietDonHang (
    maDH char(6) not null,
    maSP char(7) not null,
    soLuongDat int,
    donGia money,
    PRIMARY KEY (maDH, maSP),
    FOREIGN KEY (maDH) REFERENCES DonDatHang_HoaDon(maDH),
    FOREIGN KEY (maSP) REFERENCES SanPham(maSP)
);

--tạo bảng QuocGia
CREATE TABLE QuocGia (
    idQG char(5) PRIMARY KEY not null,
    tenQG nvarchar(30) not null
);

--tạo bảng TinhThanh
CREATE TABLE TinhThanh (
    idTinh char(5) PRIMARY KEY not null,
    maQG char(5) not null,
    tenTinh nvarchar(20) not null,
    FOREIGN KEY (maQG) REFERENCES QuocGia(idQG)
);

--tạo bảng QuanHuyen 
CREATE TABLE QuanHuyen (
    idQuan char(5) PRIMARY KEY not null,
    maTinh char(5) not null,
    tenQuan nvarchar(30) not null,
    FOREIGN KEY (maTinh) REFERENCES TinhThanh(idTinh)
);

--tạo bảng XaPhuong 
CREATE TABLE XaPhuong (
    idXa char(6) PRIMARY KEY not null,
    maQuan char(5) not null,
    tenXa nvarchar(20) not null,
    FOREIGN KEY (maQuan) REFERENCES QuanHuyen(idQuan)
);

--tạo bảng chức vụ
create table Chuc_vu (
	idCV char(4) primary key not null,
	tenCV nvarchar(50) not null
);

--tạo bảng nhân viên-chức vụ
create table NhanVien_ChucVu(
	maCV char(4),
	idNV char(5),
	primary key (maCV, idNV),
	foreign key (maCV) references Chuc_vu (idCV)
		ON UPDATE
			CASCADE
		ON DELETE
			CASCADE,
	foreign key (idNV) references NhanVien (maNV)
		ON UPDATE
			CASCADE
		ON DELETE
			CASCADE,
);

-- Xóa diaChiKH khỏi bảng KhachHang
ALTER TABLE KhachHang
DROP COLUMN diaChiKH;

-- Xóa diaChiGiaoHang khỏi bảng DonDatHang_HoaDon
ALTER TABLE DonDatHang_HoaDon
DROP COLUMN diaChiGiaoHang;

-- Xóa diaChiNCC khỏi bảng NhaCungCap
ALTER TABLE NhaCungCap
DROP COLUMN diaChiNCC;

-- Thêm maXa và soNha vào bảng KhachHang
ALTER TABLE KhachHang
ADD maXa char(6) NOT NULL,
    soNha nvarchar(50),
    FOREIGN KEY (maXa) REFERENCES XaPhuong(idXa);

-- Thêm maXa và soNha vào bảng DonDatHang_HoaDon
ALTER TABLE DonDatHang_HoaDon
ADD maXa char(6) NOT NULL,
    soNha nvarchar(50),
    FOREIGN KEY (maXa) REFERENCES XaPhuong(idXa);

-- Thêm maXa và soNha vào bảng NhaCungCap
ALTER TABLE NhaCungCap
ADD maXa char(6) NOT NULL,
    soNha nvarchar(50),
    FOREIGN KEY (maXa) REFERENCES XaPhuong(idXa);

ALTER TABLE DonDatHang_HoaDon
ALTER COLUMN ngayTaoDH date NULL;

--Đặt giá trị hiện tại cho ngayTaoHD
ALTER TABLE DonDatHang_HoaDon
	ADD CONSTRAINT DF_DonDatHang_HoaDon_ngayTaoDH DEFAULT GETDATE() FOR ngayTaoDH;

--ràng buộc ngày
ALTER TABLE DonDatHang_HoaDon
	ADD CONSTRAINT CK_NgayThanhToan 
		CHECK (ngayThanhToan >= ngayTaoDH),
	CONSTRAINT CK_NgayGiaoHang 
		CHECK (ngayGiaoHang >= ngayThanhToan);

--ràng buộc gía trị trạng thái đơn hàng
ALTER TABLE DonDatHang_HoaDon
	ADD CONSTRAINT CK_TrangThaiDH 
		CHECK (trangThaiDH IN (N'chờ xác nhận', N'đang giao', N'giao thành công', N'giao không thành công', N'đã hủy'));
ALTER TABLE DonDatHang_HoaDon
	ADD CONSTRAINT DF_TrangThaiDH DEFAULT N'chờ xác nhận' FOR trangThaiDH;

--ràng buộc cho trường SDT trong bảng KhachHang
ALTER TABLE KhachHang
	ADD CONSTRAINT CK_SDT_KhachHang
	CHECK (SDT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR 
			SDT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

--ràng buộc cho trường SDT trong bảng NhanVien
ALTER TABLE NhanVien
	ADD CONSTRAINT CK_SDT_NhanVien
	CHECK (SDT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR 
			SDT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

--ràng buộc cho trường SDT trong bảng NhaCungCap
ALTER TABLE NhaCungCap
	ADD CONSTRAINT CK_SDT_NhaCungCap
	CHECK (SDT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR 
			SDT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

--ràng buộc cho trường SDTGiaoHang trong bảng DonDatHang_HoaDon
ALTER TABLE DonDatHang_HoaDon
	ADD CONSTRAINT CK_SDT_DonDatHang_HoaDon
	CHECK (SDTGiaoHang LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR 
			SDTGiaoHang LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

--ràng buộc giới tính
ALTER TABLE NhanVien
	ADD CONSTRAINT CK_GioiTinh 
		CHECK (gioiTinh IN (N'Nam', N'Nữ')),
	CONSTRAINT DF_GioiTinh DEFAULT 'Nam' FOR gioiTinh;

--ràng buộc tuổi nhân viên
ALTER TABLE NhanVien
	ADD CONSTRAINT CK_DoB 
		CHECK (DoB <= DATEADD(YEAR, -18, GETDATE()));

ALTER TABLE NhanVien
ALTER COLUMN Salary money NULL;

--ràng buộc lương nhân viên
	ALTER TABLE NhanVien
		ADD CONSTRAINT CK_Salary 
	CHECK (Salary >= 0),
		CONSTRAINT DF_Salary DEFAULT 5000000 FOR Salary;
--ràng buộc cho trường Email trong bảng KhachHang
ALTER TABLE KhachHang
	ADD CONSTRAINT CK_Email_KhachHang
		CHECK (Email LIKE '[a-zA-Z]%@_%');

--ràng buộc cho trường Email trong bảng NhanVien
ALTER TABLE NhanVien
	ADD CONSTRAINT CK_Email_NhanVien
		CHECK (Email LIKE '[a-zA-Z]%@_%');

-- thiết lập on delete và on update
--Bảng DonDatHang_HoaDon

ALTER TABLE DonDatHang_HoaDon
	ADD CONSTRAINT FK_DonDatHang_HoaDon_KhachHang
	FOREIGN KEY (maKH) REFERENCES KhachHang(maKH)
	ON UPDATE
		CASCADE
	ON DELETE
		CASCADE; 

ALTER TABLE DonDatHang_HoaDon
	ADD CONSTRAINT FK_DonDatHang_HoaDon_NhanVien
	FOREIGN KEY (maNV) REFERENCES NhanVien(maNV)
	ON UPDATE
		CASCADE
	ON DELETE
		CASCADE;

--Bảng ChiTietDonHang
	
ALTER TABLE ChiTietDonHang
	ADD CONSTRAINT FK_ChiTietDonHang_DonDatHang
	FOREIGN KEY (maDH) REFERENCES DonDatHang_HoaDon(maDH)
	ON UPDATE
		CASCADE
	ON DELETE
		CASCADE;

ALTER TABLE ChiTietDonHang
	ADD CONSTRAINT FK_ChiTietDonHang_SanPham
	FOREIGN KEY (maSP) REFERENCES SanPham(maSP)
	ON UPDATE
		CASCADE
	ON DELETE
		CASCADE;

--Bảng ChiTietPhieuNhap
	
ALTER TABLE ChiTietPhieuNhap
	ADD CONSTRAINT FK_ChiTietPhieuNhap_PhieuNhap
	FOREIGN KEY (maPN) REFERENCES PhieuNhap(maPN)
	ON UPDATE
		CASCADE
	ON DELETE
		CASCADE;

ALTER TABLE ChiTietPhieuNhap
	ADD CONSTRAINT FK_ChiTietPhieuNhap_SanPham
	FOREIGN KEY (maSP) REFERENCES SanPham(maSP)
	ON UPDATE
		CASCADE
	ON DELETE
		CASCADE;

--Bảng PhieuNhap

ALTER TABLE PhieuNhap
	ADD CONSTRAINT FK_PhieuNhap_NhaCungCap
	FOREIGN KEY (maNCC) REFERENCES NhaCungCap(maNCC)
	ON UPDATE
		CASCADE
	ON DELETE
		CASCADE;

--Bảng TinhThanh

ALTER TABLE TinhThanh
	ADD CONSTRAINT FK_TinhThanh_QuocGia
	FOREIGN KEY (maQG) REFERENCES QuocGia(idQG)
	ON UPDATE
		CASCADE
	ON DELETE
		CASCADE;

--Bảng QuanHuyen

ALTER TABLE QuanHuyen
	ADD CONSTRAINT FK_QuanHuyen_TinhThanh
	FOREIGN KEY (maTinh) REFERENCES TinhThanh(idTinh)
	ON UPDATE
		CASCADE
	ON DELETE
		CASCADE;

--Bảng XaPhuong

ALTER TABLE XaPhuong
	ADD CONSTRAINT FK_XaPhuong_QuanHuyen
	FOREIGN KEY (maQuan) REFERENCES QuanHuyen(idQuan)
	ON UPDATE
		CASCADE
	ON DELETE
		CASCADE;

SET DATEFORMAT dmy;
--thêm dữ liệu vào bảng QuocGia 

INSERT INTO QuocGia (idQG, tenQG)
VALUES
	('QG001', N'Việt Nam'),
	('QG002', N'Mỹ'),
	('QG003', N'Nhật Bản'),
	('QG004', N'Hàn Quốc'),
	('QG005', N'Trung Quốc'),
	('QG006', N'Anh'),
	('QG007', N'Pháp'),
	('QG008', N'Đức'),
	('QG009', N'Úc'),
	('QG010', N'Canada');

--thêm dữ liêụ vào bảng tỉnh thành 

INSERT INTO TinhThanh (idTinh, maQG, tenTinh) 
VALUES
	('TT001', 'QG001', N'Hà Nội'),
	('TT002', 'QG001', N'Hồ Chí Minh'),
	('TT003', 'QG001', N'Đà Nẵng'),
	('TT004', 'QG001', N'Hải Phòng'),
	('TT005', 'QG001', N'Bình Dương'),
	('TT006', 'QG001', N'Quảng Ninh'),
	('TT007', 'QG001', N'Hưng Yên'),
	('TT008', 'QG001', N'Hải Dương'),
	('TT009', 'QG001', N'Thừa Thiên Huế'),
	('TT010', 'QG001', N'Nghệ An');

--thêm dữ liệu vào bảng QuanHuyen

INSERT INTO QuanHuyen (idQuan, tenQuan, maTinh) 
VALUES
	('QH001', N'Ba Đình', 'TT001'),
	('QH002', N'Hoàn Kiếm', 'TT001'),
	('QH003', N'Thủ Đức', 'TT002'),
	('QH004', N'Bình Thạnh', 'TT002'),
	('QH005', N'Hải Châu', 'TT003'),
	('QH006', N'Lê Chân', 'TT004'),
	('QH007', N'Dĩ An', 'TT005'),
	('QH008', N'Uông Bí', 'TT006'),
	('QH009', N'Kim Động', 'TT007'),
	('QH010', N'Tứ Kỳ', 'TT008');

--thêm dữ liệu vào bảng XaPhuong

INSERT INTO XaPhuong (idXa, tenXa, maQuan) 
VALUES
	('PX0001', N'Phúc Xá', 'QH001'),
	('PX0002', N'Trúc Bạch', 'QH001'),
	('PX0003', N'Hàng Bài', 'QH002'),
	('PX0004', N'Hàng Đào', 'QH002'),
	('PX0005', N'Hiệp Bình Chánh', 'QH003'),
	('PX0006', N'Hiệp Bình Phước', 'QH003'),
	('PX0007', N'Phường 19', 'QH004'),
	('PX0008', N'Phường 21', 'QH004'),
	('PX0009', N'Hòa Cường Nam', 'QH005'),
	('PX0010', N'Hòa Cường Bắc', 'QH005');

--thêm dữ liệu vào bảng NhaCungCap

INSERT INTO NhaCungCap (maNCC, tenNCC, SDT, nhanVienLienHe, maXa, soNha) 
VALUES
	('NCC003', N'Công ty An bình', '0912345699', N'Tran Van S', 'PX0003', '40D'),
	('NCC004', N'Công ty Thịnh phát', '0912345700', N'Le Thi T', 'PX0001', '50C'),
	('NCC005', N'Công ty NCC', '0912345701', N'Nguyen Van U', 'PX0002', '60B'),
	('NCC006', N'Công ty LCDM', '0912345702', N'Pham Thi V', 'PX0003', '70A'),
	('NCC007', N'Công ty HSG', '0912345703', N'Hoang Van W', 'PX0004', '80D'),
	('NCC008', N'Công ty VRE', '0912345704', N'Le Thi X', 'PX0002', '90B'),
	('NCC009', N'Công ty VHM', '0912345705', N'Ngo Van Y', 'PX0001', '100C'),
	('NCC010', N'Công ty VNM', '0912345706', N'Bui Thi Z', 'PX0004', '110A'),
	('NCC001', N'Công ty VIC', '0912345678', N'Nguyen Van A', 'PX0007','20H'),
	('NCC002', N'Công ty AAA', '0912345679', N'Vo Van C', 'PX0007','19A');

INSERT INTO NhaCungCap (maNCC, tenNCC, SDT, nhanVienLienHe, maXa, soNha)
VALUES ('NCC012', N'Công ty H', '0912345679', N'Vo Van C', 'PX0007', '29A');



--thêm dữ liệu vào bảng NhanVien 

INSERT INTO NhanVien (maNV, tenNV, SDT, Email, gioiTinh, DoB, Salary) 
VALUES
	('NV001', N'Pham Van D', '0912345681', 'd@example.com', N'Nam', '01-01-1990', 6000000),
	('NV002', N'Nguyen Thi E', '0912345682', 'e@example.com', N'Nữ', '01-02-1988', 7000000),
	('NV003', N'Le Van K', '0912345691', 'k@example.com', N'Nam', '05-06-1987', 8000000),
	('NV004', N'Tran Thi L', '0912345692', 'l@example.com', N'Nữ', '10-07-1986', 8500000),
	('NV005', N'Nguyen Van M', '0912345693', 'm@example.com', N'Nam', '15-08-1985', 9000000),
	('NV006', N'Hoang Thi N', '0912345694', 'n@example.com', N'Nữ', '20-09-1984', 9500000),
	('NV007', N'Pham Van O', '0912345695', 'o@example.com', N'Nam', '25-10-1983', 10000000),
	('NV008', N'Le Thi P', '0912345696', 'p@example.com', N'Nữ', '30-11-1982', 10500000),
	('NV009', N'Bui Van Q', '0912345697', 'q@example.com', N'Nam', '05-12-1981', 11000000),
	('NV010', N'Ngo Thi R', '0912345698', 'r@example.com', N'Nữ', '10-01-1980', 11500000);

--thêm dữ liệu vào bảng phiếu nhập 

INSERT INTO PhieuNhap (maPN, maNCC, ngayNhapHang) 
VALUES
	('PN00100', 'NCC001', '02-09-2023'),
	('PN00200', 'NCC002', '03-09-2023'),
	('PN00300', 'NCC003', '04-09-2023'),
	('PN00400', 'NCC004', '05-09-2023'),
	('PN00500', 'NCC005', '06-09-2023'),
	('PN00600', 'NCC006', '07-09-2023'),
	('PN00700', 'NCC007', '08-09-2023'),
	('PN00800', 'NCC008', '09-09-2023'),
	('PN00900', 'NCC009', '10-09-2023'),
	('PN01000', 'NCC010', '11-09-2023');

--chèn dữ liệu vào bảng SanPham

INSERT INTO SanPham (maSP, tenSP, donGia, soLuongCon, soLuongCanDuoi) 
VALUES
	('SP00001', N'Điện thoại', 50000, 100, 10),
	('SP00002', N'Máy Tính', 100000, 50, 5),
	('SP00003', N'Đồ gia dụng', 150000, 200, 20),
	('SP00004', N'Mĩ phẩm', 200000, 300, 15),
	('SP00005', N'Thuốc', 250000, 400, 25),
	('SP00006', N'Hóa chất vệ sinh', 300000, 500, 30),
	('SP00007', N'Thực phẩm đóng hộp', 350000, 600, 35),
	('SP00008', N'Nước uống', 400000, 700, 40),
	('SP00009', N'Tủ lạnh', 450000, 800, 45),
	('SP01000', N'Xe máy', 500000, 900, 50);


--thêm dữ liệu vào bảng ChiTietPhieuNhap

INSERT INTO ChiTietPhieuNhap (maPN, maSP, soLuongNhap, giaNhap) 
VALUES
	('PN00100', 'SP00001', 100, 100000),
	('PN00100', 'SP00002', 50, 200000),
	('PN00100', 'SP00003', 75, 150000),
	('PN00200', 'SP00002', 80, 200000),
	('PN00300', 'SP00003', 60, 150000),
	('PN00400', 'SP00001', 90, 100000),
	('PN00500', 'SP00004', 120, 250000),
	('PN00600', 'SP00005', 130, 300000),
	('PN00700', 'SP00006', 140, 350000),
	('PN00800', 'SP00007', 150, 400000),
	('PN00900', 'SP00008', 160, 450000),
	('PN01000', 'SP01000', 170, 500000);

--thêm dữ liệu vào bảng KhachHang

INSERT INTO KhachHang (maKH, tenKH, SDT, Email, soDuTaiKhoan, maXa, soNha) 
VALUES
	('KH0001', N'Nguyen Van A', '0912345678', 'a@example.com', 1000000, 'PX0001', '12B'),
	('KH0002', N'Le Thi B', '0912345679', 'b@example.com', 2000000, 'PX0002', '10C'),
	('KH0003', N'Tran Van C', '0912345680', 'c@example.com', 3000000, 'PX0001', '15A'),
	('KH0004', N'Nguyen Thi D', '0912345684', 'd@example.com', 1500000, 'PX0002', '15B'),
	('KH0005', N'Le Van E', '0912345685', 'e@example.com', 2500000, 'PX0003', '20A'),
	('KH0006', N'Hoang Van F', '0912345686', 'f@example.com', 3500000, 'PX0004', '22C'),
	('KH0007', N'Pham Thi G', '0912345687', 'g@example.com', 4500000, 'PX0010', '18B'),
	('KH0008', N'Tran Van H', '0912345688', 'h@example.com', 5500000, 'PX0002', '25D'),
	('KH0009', N'Bui Thi I', '0912345689', 'i@example.com', 6500000, 'PX0003', '30C'),
	('KH0010', N'Ngo Van J', '0912345690', 'j@example.com', 7500000, 'PX0004', '35A');
SET DATEFORMAT dmy;
--thêm dữ liệu vào bảng DonDatHang_HoaDon 
INSERT INTO DonDatHang_HoaDon (maDH, maKH, maNV, ngayTaoDH, maXa, soNha,SDTGiaoHang,maHDDienTu,ngayThanhToan,ngayGiaoHang,trangThaiDH)
VALUES
    ('DH0001', 'KH0001', 'NV001', GETDATE(), 'PX0001', N'123 Đường A','0912345678','00000001',GETDATE()+1,GETDATE()+2,DEFAULT),
    ('DH0002', 'KH0002', 'NV002', GETDATE(), 'PX0002', N'456 Đường B','0912345679','00000002',GETDATE()+1,GETDATE()+2,N'đã hủy'),
    ('DH0003', 'KH0010', 'NV003', GETDATE(), 'PX0003', N'789 Đường C','0912345690','00000003',GETDATE()+1,GETDATE()+2,DEFAULT),
    ('DH0004', 'KH0003', 'NV001', GETDATE(), 'PX0001', N'321 Đường D','0912345680','00000004',GETDATE()+1,GETDATE()+2,N'đang giao'), 
    ('DH0005', 'KH0004', 'NV004', GETDATE(), 'PX0004', N'654 Đường E','0912345684','00000005',GETDATE()+1,GETDATE()+2,DEFAULT),
    ('DH0006', 'KH0002', 'NV002', GETDATE(), 'PX0005', N'987 Đường F','0912345679','00000006',GETDATE()+1,GETDATE()+2,DEFAULT), 
    ('DH0007', 'KH0005', 'NV003', GETDATE(), 'PX0002', N'432 Đường G','0912345685','00000007',GETDATE()+1,GETDATE()+2,DEFAULT), 
    ('DH0008', 'KH0006', 'NV001', GETDATE(), 'PX0006', N'876 Đường H','0912345686','00000008',GETDATE()+1,GETDATE()+2,N'giao thành công'), 
    ('DH0009', 'KH0001', 'NV005', GETDATE(), 'PX0007', N'123 Đường I','0912345678','00000009',GETDATE()+1,GETDATE()+2,N'giao không thành công'), 
    ('DH0010', 'KH0007', 'NV002', GETDATE(), 'PX0008', N'789 Đường J','0912345690','00000010',GETDATE()+1,GETDATE()+2,N'đã hủy'); 

--thêm dữ liệu vào bảng ChiTietDonHang

INSERT INTO ChiTietDonHang 
VALUES 
	('DH0001','SP00001',10,50000),
	('DH0001','SP01000',31,500000),
	('DH0002','SP00001',30,50000),
	('DH0003','SP00007',25,350000),
	('DH0004','SP00003',20,150000),
	('DH0005','SP00004',11,200000),
	('DH0006','SP00006',11,300000),
	('DH0007','SP00002',17,100000),
	('DH0007','SP00005',50,250000),
	('DH0008','SP00009',40,450000);

--thêm dữ liệu vào bảng chức vụ
INSERT INTO Chuc_vu
VALUES 
	('CV01',N'Nhân viên xử lí đơn'),
	('CV02',N'Nhân viên vận đơn'),
	('CV03',N'Quản lí'),
	('CV04',N'Logistic'),
	('CV05',N'IT');

--thêm dữ liệu vào bảng NhanVien_ChucVu

INSERT INTO NhanVien_ChucVu
VALUES
	('CV01','NV001'),
	('CV01','NV002'),
	('CV02','NV003'),
	('CV03','NV005'),
	('CV05','NV004');

--Câu 1: Hãy bổ sung cột KHTT trong bảng Khách hàng (để đảm bảo tương thích với 10 dòng dữ liệu đã có của bảng Khách hàng)
--> sau đó cập nhật giá trị của cột KHTT thành 'Thân thiết' với những khách hàng đã từng đặt mua đơn hàng và trạng thái đơn hàng là 'Thành công';

ALTER TABLE KhachHang
	ADD KHTT NVARCHAR(30) NOT NULL,
	CONSTRAINT DF_KHACHHANG_KHTT DEFAULT N'Khách hàng thân thiết' FOR KHTT
GO
UPDATE KhachHang 
	SET KHTT = N'Khách hàng thân thiết'
	SELECT DISTINCT KH.*
	FROM KHACHHANG KH, DonDatHang_HoaDon DDH
	WHERE (KH.maKH= DDH.maKH) 
		AND DDH.trangThaiDH =N'giao thành công'

--Câu 2: Hãy xóa những nhà cung cấp mà chưa từng cung cấp hàng 
--> về nguyên tắc, chỉ lưu thông tin nhà cung cấp nào đã từng cung cấp hàng của công ty/doanh nghiệp mình;
DELETE FROM NhaCungCap
	WHERE maNCC NOT IN (SELECT DISTINCT maNCC FROM PhieuNhap);

--Câu 3: Hãy hiển thị thông tin chi tiết của những sản phẩm đã từng được khách hàng mua?
SELECT SP.*
FROM SANPHAM SP, ChiTietDonHang ct, DonDatHang_HoaDon DDH
WHERE SP.maSP = CT.maSP 
	AND CT.maDH = DDH.maDH 
	AND DDH.trangThaiDH = N'giao thành công'

--Câu 4: Hãy hiển thị thông tin chi tiết của những sản phẩm đã từng được khách hàng mua, và có tổng số lượng sản phẩm được mua lớn hơn 10?
SELECT TENSP, SUM(soLuongDat) AS TONGSOLUONGDAT
FROM SANPHAM SP, ChiTietDonHang ct, DonDatHang_HoaDon DDH
WHERE SP.maSP = CT.maSP AND CT.maDH = DDH.maDH 
	AND DDH.trangThaiDH = N'giao thành công'
GROUP BY TENSP
HAVING SUM(SoLuongDat)>10

--Câu 5: Hãy hiên thị thông tin những đơn hàng có trạng thái 'Chờ xử lý'
--(đổi giá trị cột Trạng thái đơn hàng thành 5 trạng thái như buổi học online hôm qua yêu cầu)?
SELECT DDH.*
FROM DonDatHang_HoaDon DDH
WHERE DDH.trangThaiDH =N'chờ xác nhận'

-- Câu 6: Hãy đếm số đơn hàng theo mỗi trạng thái?
SELECT trangThaiDH, COUNT(*) AS soDonHang
FROM DonDatHang_HoaDon
GROUP BY trangThaiDH;

-- Tìm chức vụ của NV001
select tenCV
from NhanVien_ChucVu nvc
	join Chuc_Vu ON nvc.maCV = Chuc_Vu.idCV
where idNV = 'NV001'

---------------------------------------------Bài tập tạo View--------------------------------------------------

--tạo view bảng KhachHang
CREATE VIEW vw_KhachHang_HoTen AS
SELECT 
    maKH,
    SUBSTRING(tenKH, 1, CHARINDEX(' ', tenKH) - 1) AS Ho,
    LTRIM(SUBSTRING(tenKH, CHARINDEX(' ', tenKH) + 1, LEN(tenKH))) AS TenLot
FROM KhachHang;

SELECT * FROM vw_KhachHang_HoTen;

--tạo view bảng NhanVien
CREATE VIEW vw_NhanVien_HoTen AS
SELECT 
    maNV,
    SUBSTRING(tenNV, 1, CHARINDEX(' ', tenNV) - 1) AS Ho,
    LTRIM(SUBSTRING(tenNV, CHARINDEX(' ', tenNV) + 1, LEN(tenNV))) AS TenLot
FROM NhanVien;

SELECT * FROM vw_NhanVien_HoTen;

--tạo view chỉ chứa thông tin những nhân viên còn đang làm việc
CREATE VIEW vw_NhanVien_DangLamViec AS
SELECT 
    maNV,
    tenNV,
    SDT,
    Email,
    gioiTinh,
    DoB,
    Salary
FROM NhanVien
WHERE Salary IS NOT NULL;
--cập nhật lại để kiếm tra
UPDATE NhanVien
SET Salary = NULL
WHERE maNV = 'NV010';

SELECT * FROM vw_NhanVien_DangLamViec;

------------------------------------------------- Bài tập hàm và thủ tục --------------------------------------
*/

/*
	Câu 1:  Hiển thị thông tin đầy đủ về tất cả sản phẩm, và cột được đặt tên là 'Tình trạng' nhận 1 trong các giá trị sau:
			+ 'Hết' nếu soLuongCanDuoi = 0
			+ 'Gần hết' nếu soLuongCanDuoi < 10
			+ 'Còn vô tư' nếu soLuongCanDuoi >=10
*/
--cập nhật để kiểm tra thủ tục
Update SanPham
set soLuongCanDuoi = 0
where maSP = 'SP01000'

CREATE PROC pr_INFO_SanPham_TinhTrang
AS
BEGIN
    SELECT *,
		CASE 
			WHEN soLuongCanDuoi = 0 THEN N'Hết'
			WHEN soLuongCanDuoi < 10 THEN N'Gần hết'
			ELSE N'Còn vô tư'
		END AS N'Tình trạng'
	FROM SanPham
END
GO
EXEC Pr_INFO_SanPham_TinhTrang;

/*
	Viết hàm:
	GO
	CREATE FUNCTION fn_Info_SanPham_TinhTrang()
	RETURNS TABLE
	AS
	RETURN
	(
		SELECT *,
			CASE 
				WHEN soLuongCanDuoi = 0 THEN N'Hết'
				WHEN soLuongCanDuoi < 10 THEN N'Gần hết'
				ELSE N'Còn vô tư'
			END AS N'Tình trạng'
		FROM SanPham
	);
	GO
	SELECT * FROM dbo.fn_Info_SanPham_TinhTrang();
*/

-- Câu 2:  Thống kê (tìm kiếm) những sản phẩm có tên chứa @ten và giá bán ra < @gia (với @ten và &gia là tham số vào)

create procedure pr_ThongKe_SPham
	@giaSP money,
	@tenSP nvarchar(50)
as
begin
	select maSP, tenSP, donGia
	from SanPham
	where tenSP like '%'+@tenSP+'%'
		and donGia <@giaSP
end
go
execute pr_ThongKe_SPham @giaSP = 10000000, @tenSP = N'Xe'

/*
	Viết Hàm:
	GO
	CREATE FUNCTION fn_ThongKeSanPham 
	(
		@ten NVARCHAR(50),
		@gia MONEY
	)
	RETURNS TABLE
	AS
	RETURN
	(
		SELECT *
		FROM SanPham
		WHERE tenSP LIKE '%' + @ten + '%'
			  AND donGiaBan < @gia
	);
	GO
	DECLARE @ten NVARCHAR(50) = N'T';
	DECLARE @gia MONEY = 350000;

	SELECT * FROM dbo.fn_ThongKeSanPham(@ten, @gia);
*/

-- Câu 3:  Thống kê những giá đã từng bán ra của 1 sản phẩm (với @maSP là tham số vào)
create procedure pr_ThongKeGiaBan 
	@maSP char(7)
as
begin
	select distinct ct.maSP, tenSP, ct.donGia
	from ChiTietDonHang ct
	join SanPham sp on ct.maSP = sp.maSP
	where ct.maSP = @maSP
end
go
execute pr_ThongKeGiaBan 'SP00002'

-- Câu 4:  Thống kê những sản phẩm có giá bán trong đoạn [@min,@max] với @min và @max là hai tham số vào 
-- (sắp xếp giảm dần theo giá, tăng dần theo mã sản phẩm)

create procedure pr_ThongKeTheoDoan
	@giaMin money,
	@giaMax money
as
begin
	select *
	from SanPham
	where donGia between @giaMin and @giaMax
	order by donGia desc,
			maSP asc;
end
exec pr_ThongKeTheoDoan 200000,400000

/*
	Viết hàm:
	GO
	CREATE FUNCTION fn_ThongKeGiaTrongKhoang
	(
		@min MONEY,
		@max MONEY
	)
	RETURNS TABLE
	AS
	RETURN
	(
		SELECT *
		FROM SanPham
		WHERE donGiaBan BETWEEN @min AND @max
	);
	GO
	DECLARE @min MONEY = 200000;
	DECLARE @max MONEY = 350000;
	SELECT * FROM dbo.fn_ThongKeGiaTrongKhoang(@min, @max);
*/

-- Câu 5: Tăng tự động các column ID cho tất cả table sinh ra từ thực thể mạnh

GO
CREATE PROCEDURE pr_ThemIDTuDong
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TenBang NVARCHAR(255);
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @Message NVARCHAR(500);
    -- Con trỏ để duyệt qua tất cả các bảng
    DECLARE BangCursor CURSOR FOR
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE = 'BASE TABLE';
    OPEN BangCursor;
    FETCH NEXT FROM BangCursor INTO @TenBang;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Kiểm tra xem cột ID đã tồn tại chưa
        IF NOT EXISTS (
            SELECT * 
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = @TenBang AND COLUMN_NAME = 'ID'
        )
        BEGIN
            -- Tạo câu lệnh SQL để thêm cột ID
            SET @SQL = 'ALTER TABLE ' + QUOTENAME(@TenBang) + 
                        ' ADD ID INT IDENTITY(1,1);';
            EXEC sp_executesql @SQL;
            -- Ghi lại thông báo
            SET @Message = N'Đã thêm cột ID vào bảng: ' + @TenBang;
            PRINT @Message;
            -- Kiểm tra xem bảng đã có khóa chính chưa
            IF NOT EXISTS (
                SELECT * 
                FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
                WHERE TABLE_NAME = @TenBang AND CONSTRAINT_TYPE = 'PRIMARY KEY'
            )
            BEGIN
                -- Thiết lập ID là PRIMARY KEY nếu bảng chưa có khóa chính
                SET @SQL = 'ALTER TABLE ' + QUOTENAME(@TenBang) + 
                            ' ADD CONSTRAINT PK_' + @TenBang + '_ID PRIMARY KEY (ID);';
                EXEC sp_executesql @SQL;
                -- Ghi lại thông báo
                SET @Message = N'Đã thiết lập ID là khóa chính cho bảng: ' + @TenBang;
                PRINT @Message;
            END
            ELSE
            BEGIN
                SET @Message = N'Bảng ' + @TenBang + N' đã có khóa chính, không thêm khóa chính cho ID.';
                PRINT @Message;
            END
        END
        ELSE
        BEGIN
            SET @Message = N'Cột ID đã tồn tại trong bảng: ' + @TenBang;
            PRINT @Message;
        END

        FETCH NEXT FROM BangCursor INTO @TenBang;
    END

    CLOSE BangCursor;
    DEALLOCATE BangCursor;
END
GO 
EXEC pr_ThemIDTuDong;


-- Câu 6: Thống kê các sản phẩm bán chạy (có tham số vào là số các sản phẩm cần thống kê)

CREATE PROCEDURE Pr_ThongKeSanPhamBanChay
    @soLuong INT
AS
BEGIN
    SELECT TOP(@soLuong) 
        sp.maSP, 
        tenSP, 
        SUM(soLuongDat) AS TongSoLuongBan
    FROM SanPham sp
    JOIN ChiTietDonHang ct ON sp.maSP = ct.maSP
    GROUP BY sp.maSP, tenSP
    ORDER BY TongSoLuongBan DESC; 
END
GO
EXEC Pr_ThongKeSanPhamBanChay @soLuong = 5;

-- Câu 7:  Thống kê những tháng có doanh thu trên một giá trị định mức nào đó (định mức là tham số vào)

CREATE PROCEDURE pr_ThongKeDoanhThu_DinhMuc
    @dinhMuc money
AS
BEGIN
    SELECT 
		MONTH(ddh.ngayTaoDH) AS Thang,
        YEAR(ddh.ngayTaoDH) AS Nam,
		Sum(SoLuongDat*DonGia) as DoanhThu
    FROM DonDatHang_HoaDon ddh
	JOIN ChiTietDonHang ct on ddh.maDH = ct.maDH
    WHERE ddh.trangThaiDH = N'giao thành công'
    GROUP BY MONTH(ddh.ngayTaoDH), YEAR(ddh.ngayTaoDH)
    HAVING Sum(SoLuongDat*DonGia) > @dinhMuc
	ORDER BY Nam, Thang; 
END
GO
EXEC pr_ThongKeDoanhThu_DinhMuc @dinhMuc = 1000000;

-- Câu 8:  Thống kê giá trung bình, giá max, giá min ở các phiếu nhập hàng cho mỗi sản phẩm

CREATE PROCEDURE pr_ThongKeGia_TB_Max_Min
AS
BEGIN
	SELECT 
        sp.maSP, 
        sp.tenSP,
        AVG(ct.giaNhap) AS GiaTrungBinh, 
        MAX(ct.giaNhap) AS GiaMax,       
        MIN(ct.giaNhap) AS GiaMin        
    FROM ChiTietPhieuNhap ct
    JOIN SanPham sp ON ct.maSP = sp.maSP
    GROUP BY sp.maSP, sp.tenSP
END
GO
EXEC pr_ThongKeGia_TB_Max_Min;

-- Câu 9: Thống kê số lần khách hàng mua hàng (sắp xếp giảm dần)

create proc pr_ThongKeKhachHangMua
as
begin
    SELECT kh.maKH, tenKH,
        COUNT(ddh.maDH) AS SoLanMua
    FROM KhachHang kh
    LEFT JOIN DonDatHang_HoaDon ddh ON kh.maKH = ddh.maKH
    GROUP BY kh.maKH, tenKH
    ORDER BY SoLanMua DESC;
end
go
execute pr_ThongKeKhachHangMua;

-- Câu 10: Thống kê số lượng khách mua hàng theo từng tỉnh/thành phố
-- (sắp xếp giảm dần theo số lượng, tăng dần theo mã khách hàng)

CREATE PROCEDURE Pr_ThongKe_KhachHangMua_TheoTinh
AS
BEGIN
    SELECT 
		tt.idTinh,
        tt.tenTinh,
        COUNT(kh.maKH) AS SoLuongKhachMuaHang
    FROM KhachHang kh
    JOIN XaPhuong xp ON kh.maXa = xp.idXa
    JOIN QuanHuyen qh ON xp.maQuan = qh.idQuan
    JOIN TinhThanh tt ON qh.maTinh = tt.idTinh
    GROUP BY tt.idTinh, tt.tenTinh
    ORDER BY SoLuongKhachMuaHang DESC;  
END
GO
EXEC Pr_ThongKe_KhachHangMua_TheoTinh;

--trigger cho bảng chitietdonhang
create trigger trg_AfterInsert_Chitietdonhang
on ChiTietDonHang
after insert 
as
begin
	if exists ( select *
				from ChiTietDonHang ct, SanPham sp
				where ct.soLuongDat > sp.soLuongCon)
		begin 
			print N'Mặt hàng đã chọn không đủ hàng để bán, vui lòng chọn số lượng nhỏ hơn'
			select tenSP, soLuongCon
			from ChiTietDonHang ct, SanPham sp
			where ct.soLuongDat > sp.soLuongCon
			rollback
		end
	else
		begin 
			update ChiTietDonHang 
			set donGia = SanPham.donGia
			from SanPham
			where ChiTietDonHang.donGia is null 
				and ChiTietDonHang .maSP = SanPham.maSP
		
			update SanPham
			set soLuongCon = soLuongCon - inserted.soLuongDat
			from inserted
			where SanPham.maSP = inserted.maSP
		end
end

select * from SanPham
select * from ChiTietDonHang

insert into ChiTietDonHang
values ('DH0009', 'SP00006',25,300000);

--trigger xóa đơn hàng -> hoàn lại số lượng sản phẩm trong bảng SanPham
CREATE TRIGGER trg_AfterDelete_ChiTietDonHang
ON ChiTietDonHang
AFTER DELETE
AS
BEGIN
    -- Cập nhật lại số lượng tồn kho trong bảng SanPham
    UPDATE sp
    SET sp.soLuongCon = sp.soLuongCon + d.soLuongDat
    FROM SanPham sp
    JOIN deleted d ON sp.maSP = d.maSP;
END;

--demo trigger
delete from ChiTietDonHang
where maDH = 'DH0009' and maSP ='SP00006'

select * from SanPham
select * from ChiTietDonHang

--trigger thêm phiếu nhập -> tăng số lượng hàng trong bảng SanPham và cập nhật lại donGia
CREATE TRIGGER trg_AfterInsert_ChiTietPhieuNhap
ON ChiTietPhieuNhap
AFTER INSERT
AS
BEGIN
    -- Cập nhật số lượng tồn kho và đơn giá trong bảng SanPham
    UPDATE sp
    SET 
        sp.soLuongCon = sp.soLuongCon + i.soLuongNhap,
        sp.donGia = i.giaNhap * 1.5
    FROM SanPham sp
    JOIN inserted i ON sp.maSP = i.maSP;
END;

select * from ChiTietPhieuNhap
select * from SanPham

insert into ChiTietPhieuNhap
values ('PN00300','SP00002',50,200000);


--trigger xóa phiếu nhập -> hoàn trả số lượng hàng trong bảng SanPham về trước khi nhập và hoàn trả giá bán
CREATE TRIGGER trg_AfterDelete_ChiTietPhieuNhap
ON ChiTietPhieuNhap
AFTER DELETE
AS
BEGIN
    -- Cập nhật lại số lượng tồn kho và đơn giá trong bảng SanPham
    UPDATE sp
    SET 
        sp.soLuongCon = sp.soLuongCon - d.soLuongNhap,
        sp.donGia = CASE 
                        WHEN sp.donGia IS NOT NULL THEN sp.donGia / 1.5
                        ELSE NULL
                    END
    FROM SanPham sp
    JOIN deleted d ON sp.maSP = d.maSP;
END;

delete from ChiTietPhieuNhap
where maPN = 'PN00300' and maSP ='SP00002'