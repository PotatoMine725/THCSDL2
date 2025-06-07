--Kiểm tra xem database đã tồn tại hay chưa, tồn tại thì xóa
IF EXISTS (SELECT * FROM sys.databases WHERE name = N'quanlykhachsan')
BEGIN
    -- Đóng tất cả các kết nối đến cơ sở dữ liệu
    EXECUTE sp_MSforeachdb 'IF ''?'' = ''quanlykhachsan'' 
    BEGIN
        DECLARE @sql AS NVARCHAR(MAX) = ''USE [?]; ALTER DATABASE [?] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;''
        EXEC (@sql)
    END'
    -- Xóa tất cả các kết nối tới cơ sở dữ liệu (thực hiện qua hệ thống master)
    USE master;
    -- Xóa cơ sở dữ liệu nếu tồn tại
    DROP DATABASE quanlykhachsan;
END

go
--tạo database tên "QLBH" - Quản lý bán hàng
create database quanlykhachsan;

go
--Sử dụng database "QLBH" -- Quản lý bán hàng
USE quanlykhachsan;

GO
-- Bảng Role (Phân quyền)
CREATE TABLE VaiTro
(
    maVaiTro CHAR(5) PRIMARY KEY,
    tenVaiTro NVARCHAR(50) NOT NULL,
    moTa NVARCHAR(255)
);

GO
-- Bảng User (Người dùng)
CREATE TABLE NguoiDung
(
    maNguoiDung CHAR(5) PRIMARY KEY,
    tenNguoiDung NVARCHAR(100) NOT NULL,
	ngaySinh varchar(15) not null CHECK (ngaySinh LIKE '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]'),
    SDT VARCHAR(10) UNIQUE CHECK (SDT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    email NVARCHAR(100) UNIQUE CHECK (email LIKE '%@gmail.com'),
    matKhau NVARCHAR(255) NOT NULL,
	soDuTaiKhoan decimal(20,2) default 0,
    maVaiTro CHAR(5),
    FOREIGN KEY (maVaiTro) REFERENCES VaiTro(maVaiTro)
);

Go
-- Bảng Cơ sở khách sạn
CREATE TABLE ChiNhanhKhachSan
(
    maChiNhanh CHAR(5) PRIMARY KEY,
    tenChiNhanh NVARCHAR(100) NOT NULL,
    diaChi NVARCHAR(255) NULL,
    SDT VARCHAR(10) UNIQUE CHECK (SDT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

Go
-- Bảng Loại phòng
CREATE TABLE LoaiPhong
(
    maLoaiPhong CHAR(5) PRIMARY KEY,
    tenLoaiPhong NVARCHAR(50) NOT NULL,
	soLuongToiDa int,
    moTa NVARCHAR(255),
    giaPhong DECIMAL(15,2)
);

Go
-- Bảng Phòng
CREATE TABLE Phong
(
    maPhong CHAR(5) PRIMARY KEY,
    soPhong VARCHAR(10) NOT NULL,
    maLoaiPhong CHAR(5),
    soTang INT NOT NULL,
    maChiNhanh CHAR(5),
    trangThai NVARCHAR(20) CHECK (trangThai IN ('Trống', 'Có người ở', 'Đã đặt trước', 'Bảo trì')) NOT NULL,
    FOREIGN KEY (maLoaiPhong) REFERENCES LoaiPhong(maLoaiPhong),
    FOREIGN KEY (maChiNhanh) REFERENCES ChiNhanhKhachSan(maChiNhanh)
);

Go
--Bảng Loại Dịch Vụ
CREATE TABLE LoaiDichVu
(
	maLoaiDichVu char(5) PRIMARY KEY,
	tenLoaiDichVu NVARCHAR(255) not null,
	giaDichVu decimal(15,2),
	moTa NVARCHAR(255)
);

Go
--Bảng dịch vụ
CREATE TABLE DichVu
(
	maDichVu char(5) PRIMARY KEY,
	tenDichVu NVARCHAR(255) not null,
	maLoaiDichVu char(5),
	FOREIGN KEY (maLoaiDichVu) REFERENCES LoaiDichVu(maLoaiDichVu)
);

Go
-- Bảng Đặt phòng
CREATE TABLE DatPhong
(
    maDatPhong CHAR(5) PRIMARY KEY,
    maNguoiDung CHAR(5),
    maPhong CHAR(5),
	soNguoi int,
    dichVuSuDung CHAR(5),
    ngayThuePhong varchar(15) NOT NULL CHECK (ngayThuePhong LIKE '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]'),
    ngayTraPhong varchar(15) NOT NULL CHECK (ngayTraPhong LIKE '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]'),
    trangThai NVARCHAR(20) CHECK (trangThai IN ('Đã đặt', 'Hoàn thành', 'Hủy')) NOT NULL,
	--check (check_in_date >= getdate()),
	--check (check_out_date <= getdate()),
	check (ngayThuePhong < ngayTraPhong),
    FOREIGN KEY (maNguoiDung) REFERENCES NguoiDung(maNguoiDung),
    FOREIGN KEY (maPhong) REFERENCES Phong(maPhong),
    FOREIGN KEY (dichVuSuDung) REFERENCES DichVu(maDichVu)
);

Go
-- Bảng Hóa đơn
CREATE TABLE HoaDon
(
    maHoaDon CHAR(5) PRIMARY KEY,
    maDatPhong CHAR(5),
    maDichVu CHAR(5),
	nhanVienPhuTrach CHAR(5) null,
    tongTien DECIMAL(15,2) NOT NULL,
    ngayGiaoDich DATETIME NOT NULL DEFAULT GETDATE(),
    phuongThucThanhToan NVARCHAR(20) CHECK (phuongThucThanhToan IN ('Ví điện tử', 'Tiền mặt', 'Thẻ')) NOT NULL,
    FOREIGN KEY (maDatPhong) REFERENCES DatPhong(maDatPhong),
	--FOREIGN KEY (nhanVienPhuTrach) REFERENCES NguoiDung(maNguoiDung),
);
go
insert into VaiTro
values
	('R001',N'Khách hàng', 'Thượng đế tới'),
	('R002',N'Nhân Viên', 'Nô Lệ đồng tiên'),
	('R003',N'Quản lý', 'Mini Boss');

go
insert into NguoiDung
values
	('ND001', N'Khanh', '05/04/2005', '0123456789','a@gmail.com'  ,'khanh123',0,'R003'),
	('ND002', N'Hoang', '05/04/2004', '0123888789','abc@gmail.com','hoang123',0,'R002'),
	('ND003', N'Nom'  , '05/04/2006', '0123456975','ada@gmail.com','Nom123'  ,0,'R001');
go
insert into LoaiDichVu
values
	('LDV01', N'Không', 0, N'Không sử dụng dịch vụ');
go
insert into DichVu
values
	('DV001', N'Bỏ qua', 'LDV01');
Go
--Select * from DichVu;
CREATE PROCEDURE sp_LayDanhSachDichVu
AS
BEGIN
    SELECT * FROM DichVu
END
GO
--insert
CREATE PROCEDURE sp_ThemDichVu
    @maDichVu CHAR(5),
    @tenDichVu NVARCHAR(255),
    @maLoaiDichVu CHAR(5)
AS
BEGIN
    INSERT INTO DichVu VALUES (@maDichVu, @tenDichVu, @maLoaiDichVu)
END
go
--update
CREATE PROCEDURE sp_CapNhatDichVu
    @maDichVu CHAR(5),
    @tenDichVu NVARCHAR(255),
    @maLoaiDichVu CHAR(5)
AS
BEGIN
    UPDATE DichVu
    SET tenDichVu = @tenDichVu,
        maLoaiDichVu = @maLoaiDichVu
    WHERE maDichVu = @maDichVu
END
go
--delete
CREATE PROCEDURE sp_XoaDichVu
    @maDichVu CHAR(5)
AS
BEGIN
    DELETE FROM DichVu WHERE maDichVu = @maDichVu
END
GO
-------------Loai dich vu------------------
--insert
CREATE PROCEDURE sp_ThemLoaiDichVu
    @maLoaiDichVu CHAR(5),
    @tenLoaiDichVu NVARCHAR(255),
    @giaDichVu DECIMAL(15,2),
    @moTa NVARCHAR(255)
AS
BEGIN
    INSERT INTO LoaiDichVu VALUES (@maLoaiDichVu, @tenLoaiDichVu, @giaDichVu, @moTa)
END
GO
--update
CREATE PROCEDURE sp_CapNhatLoaiDichVu
    @maLoaiDichVu CHAR(5),
    @tenLoaiDichVu NVARCHAR(255),
    @giaDichVu DECIMAL(15,2),
    @moTa NVARCHAR(255)
AS
BEGIN
    UPDATE LoaiDichVu
    SET tenLoaiDichVu = @tenLoaiDichVu,
        giaDichVu = @giaDichVu,
        moTa = @moTa
    WHERE maLoaiDichVu = @maLoaiDichVu
END
GO
--delete
CREATE PROCEDURE sp_XoaLoaiDichVu
    @maLoaiDichVu CHAR(5)
AS
BEGIN
    DELETE FROM LoaiDichVu WHERE maLoaiDichVu = @maLoaiDichVu
END
GO
--select
CREATE PROCEDURE sp_LayDanhSachLoaiDichVu
AS
BEGIN
    SELECT * FROM LoaiDichVu
END
GO

--------------Nguoi Dung-----------------
--insert
CREATE PROCEDURE sp_ThemNguoiDung
    @maNguoiDung CHAR(5),
    @tenNguoiDung NVARCHAR(100),
    @ngaySinh VARCHAR(15),
    @SDT VARCHAR(10),
    @email NVARCHAR(100),
    @matKhau NVARCHAR(255),
    @soDuTaiKhoan DECIMAL(20,2),
    @maVaiTro CHAR(5)
AS
BEGIN
    INSERT INTO NguoiDung VALUES (@maNguoiDung, @tenNguoiDung, @ngaySinh, @SDT, @email, @matKhau, @soDuTaiKhoan, @maVaiTro)
END
GO
--update
CREATE PROCEDURE sp_CapNhatNguoiDung
    @maNguoiDung CHAR(5),
    @tenNguoiDung NVARCHAR(100),
    @ngaySinh VARCHAR(15),
    @SDT VARCHAR(10),
    @email NVARCHAR(100),
    @matKhau NVARCHAR(255),
    @soDuTaiKhoan DECIMAL(20,2),
    @maVaiTro CHAR(5)
AS
BEGIN
    UPDATE NguoiDung
    SET tenNguoiDung = @tenNguoiDung,
        ngaySinh = @ngaySinh,
        SDT = @SDT,
        email = @email,
        matKhau = @matKhau,
        soDuTaiKhoan = @soDuTaiKhoan,
        maVaiTro = @maVaiTro
    WHERE maNguoiDung = @maNguoiDung
END
GO
--delete    
CREATE PROCEDURE sp_XoaNguoiDung
    @maNguoiDung CHAR(5)
AS
BEGIN
    DELETE FROM NguoiDung WHERE maNguoiDung = @maNguoiDung
END
GO
--select
CREATE PROCEDURE sp_LayDanhSachNguoiDung
AS
BEGIN
    SELECT * FROM NguoiDung
END
GO

----------------Vai Tro------------------
--insert
CREATE PROCEDURE sp_ThemVaiTro
    @maVaiTro CHAR(5),
    @tenVaiTro NVARCHAR(50),
    @moTa NVARCHAR(255)
AS
BEGIN
    INSERT INTO VaiTro 
    VALUES (@maVaiTro, @tenVaiTro, @moTa)
END
GO
--update
CREATE PROCEDURE sp_CapNhatVaiTro
    @maVaiTro CHAR(5),
    @tenVaiTro NVARCHAR(50),
    @moTa NVARCHAR(255)
AS
BEGIN
    UPDATE VaiTro
    SET tenVaiTro = @tenVaiTro,
        moTa = @moTa
    WHERE maVaiTro = @maVaiTro
END
GO  
--delete
CREATE PROCEDURE sp_XoaVaiTro
    @maVaiTro CHAR(5)
AS
BEGIN
    DELETE FROM VaiTro WHERE maVaiTro = @maVaiTro
END
GO
--select
CREATE PROCEDURE sp_LayDanhSachVaiTro
AS
BEGIN
    SELECT * FROM VaiTro
END
GO

------Chi Nhanh Khach San ----------
--insert
CREATE PROCEDURE sp_ThemChiNhanhKhachSan
    @maChiNhanh CHAR(5),
    @tenChiNhanh NVARCHAR(100),
    @diaChi NVARCHAR(255),
    @SDT VARCHAR(10)
AS
BEGIN
    INSERT INTO ChiNhanhKhachSan VALUES (@maChiNhanh, @tenChiNhanh, @diaChi, @SDT)
END
GO

--update
CREATE PROCEDURE sp_CapNhatChiNhanhKhachSan
    @maChiNhanh CHAR(5),
    @tenChiNhanh NVARCHAR(100),
    @diaChi NVARCHAR(255),
    @SDT VARCHAR(10)
AS
BEGIN
    UPDATE ChiNhanhKhachSan
    SET tenChiNhanh = @tenChiNhanh,
        diaChi = @diaChi,
        SDT = @SDT
    WHERE maChiNhanh = @maChiNhanh
END
GO

--delete
CREATE PROCEDURE sp_XoaChiNhanhKhachSan
    @maChiNhanh CHAR(5)
AS
BEGIN
    DELETE FROM ChiNhanhKhachSan WHERE maChiNhanh = @maChiNhanh
END
GO

--select
CREATE PROCEDURE sp_LayDanhSachChiNhanh
AS
BEGIN
    SELECT * FROM ChiNhanhKhachSan
END
GO
--------Loai Phong----------

--insert
CREATE PROCEDURE sp_ThemLoaiPhong
    @maLoaiPhong CHAR(5),
    @tenLoaiPhong NVARCHAR(50),
    @soLuongToiDa INT,
    @moTa NVARCHAR(255),
    @giaPhong DECIMAL(15,2)
AS
BEGIN
    INSERT INTO LoaiPhong VALUES (@maLoaiPhong, @tenLoaiPhong, @soLuongToiDa, @moTa, @giaPhong)
END
GO

--update
CREATE PROCEDURE sp_CapNhatLoaiPhong
    @maLoaiPhong CHAR(5),
    @tenLoaiPhong NVARCHAR(50),
    @soLuongToiDa INT,
    @moTa NVARCHAR(255),
    @giaPhong DECIMAL(15,2)
AS
BEGIN
    UPDATE LoaiPhong
    SET tenLoaiPhong = @tenLoaiPhong,
        soLuongToiDa = @soLuongToiDa,
        moTa = @moTa,
        giaPhong = @giaPhong
    WHERE maLoaiPhong = @maLoaiPhong
END
GO

--delete
CREATE PROCEDURE sp_XoaLoaiPhong
    @maLoaiPhong CHAR(5)
AS
BEGIN
    DELETE FROM LoaiPhong WHERE maLoaiPhong = @maLoaiPhong
END
GO

--select
CREATE PROCEDURE sp_LayDanhSachLoaiPhong
AS
BEGIN
    SELECT * FROM LoaiPhong
END
GO

-----------Phong-------------
--insert
CREATE PROCEDURE sp_ThemPhong
    @maPhong CHAR(5),
    @soPhong VARCHAR(10),
    @maLoaiPhong CHAR(5),
    @soTang INT,
    @maChiNhanh CHAR(5),
    @trangThai NVARCHAR(20)
AS
BEGIN
    INSERT INTO Phong VALUES (@maPhong, @soPhong, @maLoaiPhong, @soTang, @maChiNhanh, @trangThai)
END
GO

--update
CREATE PROCEDURE sp_CapNhatPhong
    @maPhong CHAR(5),
    @soPhong VARCHAR(10),
    @maLoaiPhong CHAR(5),
    @soTang INT,
    @maChiNhanh CHAR(5),
    @trangThai NVARCHAR(20)
AS
BEGIN
    UPDATE Phong
    SET soPhong = @soPhong,
        maLoaiPhong = @maLoaiPhong,
        soTang = @soTang,
        maChiNhanh = @maChiNhanh,
        trangThai = @trangThai
    WHERE maPhong = @maPhong
END
GO

--delete
CREATE PROCEDURE sp_XoaPhong
    @maPhong CHAR(5)
AS
BEGIN
    DELETE FROM Phong WHERE maPhong = @maPhong
END
GO

--select
CREATE PROCEDURE sp_LayDanhSachPhong
AS
BEGIN
    SELECT * FROM Phong
END
GO

------- Dat Phong----------
--insert
CREATE PROCEDURE sp_ThemDatPhong
    @maDatPhong CHAR(5),
    @maNguoiDung CHAR(5),
    @maPhong CHAR(5),
    @soNguoi INT,
    @dichVuSuDung CHAR(5),
    @ngayThuePhong VARCHAR(15),
    @ngayTraPhong VARCHAR(15),
    @trangThai NVARCHAR(20)
AS
BEGIN
    INSERT INTO DatPhong VALUES (@maDatPhong, @maNguoiDung, @maPhong, @soNguoi, @dichVuSuDung, @ngayThuePhong, @ngayTraPhong, @trangThai)
END
GO

--update
CREATE PROCEDURE sp_CapNhatDatPhong
    @maDatPhong CHAR(5),
    @maNguoiDung CHAR(5),
    @maPhong CHAR(5),
    @soNguoi INT,
    @dichVuSuDung CHAR(5),
    @ngayThuePhong VARCHAR(15),
    @ngayTraPhong VARCHAR(15),
    @trangThai NVARCHAR(20)
AS
BEGIN
    UPDATE DatPhong
    SET maNguoiDung = @maNguoiDung,
        maPhong = @maPhong,
        soNguoi = @soNguoi,
        dichVuSuDung = @dichVuSuDung,
        ngayThuePhong = @ngayThuePhong,
        ngayTraPhong = @ngayTraPhong,
        trangThai = @trangThai
    WHERE maDatPhong = @maDatPhong
END
GO

--delete
CREATE PROCEDURE sp_XoaDatPhong
    @maDatPhong CHAR(5)
AS
BEGIN
    DELETE FROM DatPhong WHERE maDatPhong = @maDatPhong
END
GO

--select
CREATE PROCEDURE sp_LayDanhSachDatPhong
AS
BEGIN
    SELECT * FROM DatPhong
END
GO

---------Hoa Don----------
--insert
CREATE PROCEDURE sp_ThemHoaDon
    @maHoaDon CHAR(5),
    @maDatPhong CHAR(5),
    @maDichVu CHAR(5),
    @nhanVienPhuTrach CHAR(5),
    @tongTien DECIMAL(15,2),
    @phuongThucThanhToan NVARCHAR(20)
AS
BEGIN
    INSERT INTO HoaDon (maHoaDon, maDatPhong, maDichVu, nhanVienPhuTrach, tongTien, phuongThucThanhToan)
    VALUES (@maHoaDon, @maDatPhong, @maDichVu, @nhanVienPhuTrach, @tongTien, @phuongThucThanhToan)
END
GO

--delete
CREATE PROCEDURE sp_XoaHoaDon
    @maHoaDon CHAR(5)
AS
BEGIN
    DELETE FROM HoaDon WHERE maHoaDon = @maHoaDon
END
GO

--select
CREATE PROCEDURE sp_LayDanhSachHoaDon
AS
BEGIN
    SELECT * FROM HoaDon
END
GO

