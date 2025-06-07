create database NHH_TCSDL;
go
use NHH_TCSDL;
go

--use master;
--ALTER DATABASE NHH_TCSDL SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--GO
--drop database if exists NHH_TCSDL;
-- Tạo bảng Cơ Sở
CREATE TABLE CoSo (
    id_CS CHAR(5) PRIMARY KEY,
    TEN_CS NVARCHAR(100),
    DIA_CHI NVARCHAR(255)
);

-- Tạo bảng Khu
CREATE TABLE Khu (
    id_KHU CHAR(6) PRIMARY KEY,
    TEN_KHU NVARCHAR(100),
    id_CS CHAR(5) NOT NULL,
    FOREIGN KEY (id_CS) REFERENCES CoSo(id_CS) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tạo bảng Phòng
CREATE TABLE Phong (
    MA_PHONG CHAR(5) PRIMARY KEY,
    TEN_PHONG NVARCHAR(100),
    id_KHU CHAR(6) NOT NULL,
    SO_LG INTEGER,
    FOREIGN KEY (id_KHU) REFERENCES Khu(id_KHU) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tạo bảng Chức Vụ
CREATE TABLE ChucVu (
    ID_CHUC_VU CHAR(5) PRIMARY KEY,
    TEN_CV NVARCHAR(50)
);

-- Tạo bảng Khoa
CREATE TABLE Khoa (
    MA_KHOA CHAR(7) PRIMARY KEY,
    Ten_Khoa NVARCHAR(100)
);

-- Tạo bảng Lớp Sinh Hoạt
CREATE TABLE LopSinhHoat (
    ID_LSH CHAR(6) PRIMARY KEY,
    TEN_LSH NVARCHAR(100)
);

-- Tạo bảng Sinh Viên
CREATE TABLE SinhVien (
    MA_SV CHAR(5) PRIMARY KEY,
    TenSV NVARCHAR(100),
    MA_KHOA CHAR(7) NOT NULL,
    MA_LSH CHAR(6) NOT NULL,
    FOREIGN KEY (MA_KHOA) REFERENCES Khoa(MA_KHOA) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (MA_LSH) REFERENCES LopSinhHoat(ID_LSH) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tạo bảng Cán Bộ Lớp
CREATE TABLE CanBoLop (
    id_SV CHAR(5) NOT NULL,
    id_LSH CHAR(6) NOT NULL,
    id_CV CHAR(5) NOT NULL,
    Ngay_BD DATE,
    Ngay_KT DATE,
    PRIMARY KEY (id_SV, id_LSH, id_CV),
    FOREIGN KEY (id_SV) REFERENCES SinhVien(MA_SV) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_LSH) REFERENCES LopSinhHoat(ID_LSH) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (id_CV) REFERENCES ChucVu(ID_CHUC_VU) ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (Ngay_KT > Ngay_BD)  
);



-- Tạo bảng Giảng Viên
CREATE TABLE GiangVien (
    MA_GV CHAR(5) PRIMARY KEY,
    TEN_GV NVARCHAR(100)
);

-- Tạo bảng Chủ Nhiệm
CREATE TABLE ChuNhiem (
    ID_GV CHAR(5) NOT NULL,
    MA_LSH CHAR(6) NOT NULL,
    NGAY_BD DATE,
    NGAY_KT DATE,
    PRIMARY KEY (ID_GV, MA_LSH),
    FOREIGN KEY (ID_GV) REFERENCES GiangVien(MA_GV) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (MA_LSH) REFERENCES LopSinhHoat(ID_LSH) ON UPDATE NO ACTION ON DELETE NO ACTION,
    CHECK (NGAY_KT > NGAY_BD) 
);

-- Tạo bảng Học Kỳ
CREATE TABLE HocKy (
    MA_HK CHAR(5) PRIMARY KEY,
    TEN_HK NVARCHAR(50),
    TG_BD DATE,
    TG_KT DATE
);

-- Tạo bảng Học Phần
CREATE TABLE HocPhan (
    MA_HP CHAR(5) PRIMARY KEY,
    TEN_HP NVARCHAR(100),
    SO_TC INTEGER
);

-- Tạo bảng Lớp Học Phần
CREATE TABLE LopHP (
    MA_LHP CHAR(6) PRIMARY KEY,
    MA_HP CHAR(5) NOT NULL,
    MA_HK CHAR(5) NOT NULL,
    MA_PHONG CHAR(5) NOT NULL,
    THU NVARCHAR(9),
    TIET_BD INT,
    MA_GV CHAR(5) NOT NULL,
    Ngay_HL DATE,
    FOREIGN KEY (MA_HP) REFERENCES HocPhan(MA_HP) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (MA_HK) REFERENCES HocKy(MA_HK) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (MA_PHONG) REFERENCES Phong(MA_PHONG) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (MA_GV) REFERENCES GiangVien(MA_GV) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tạo bảng SV_LHP
CREATE TABLE SV_LHP (
    id_SV CHAR(5) NOT NULL,
    id_LHP CHAR(6) NOT NULL,
    PRIMARY KEY (id_SV, id_LHP),
    FOREIGN KEY (id_SV) REFERENCES SinhVien(MA_SV) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_LHP) REFERENCES LopHP(MA_LHP) ON UPDATE CASCADE ON DELETE CASCADE
);

--tạo bảng DIEM_TP
CREATE TABLE DIEM_TP (
    idDTP CHAR(5) PRIMARY KEY NOT NULL,
    tenDTP NVARCHAR(50) NOT NULL
);

-- Tạo bảng Lớp Học Phần - Điểm Thành Phần 
CREATE TABLE LHP_DTP (
    idLHP CHAR(6) NOT NULL,
    maDTP CHAR(5) NOT NULL,
    heSo DECIMAL(3, 2) NOT NULL,  -- Hệ số với tối đa 3 chữ số, 2 chữ số thập phân
    PRIMARY KEY (idLHP, maDTP),
    FOREIGN KEY (idLHP) REFERENCES LopHP(MA_LHP) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (maDTP) REFERENCES DIEM_TP(idDTP) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tạo bảng SV-Lớp Học Phần - Điểm Thành Phần
CREATE TABLE SV_LHP_DTP (
    idSV CHAR(5) NOT NULL,
    idLHP CHAR(6) NOT NULL,
    idDTP CHAR(5) NOT NULL,
    PRIMARY KEY (idSV, idLHP, idDTP),    
    FOREIGN KEY (idLHP) REFERENCES LopHP(MA_LHP) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (idDTP) REFERENCES DIEM_TP(idDTP) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (idSV) REFERENCES SinhVien(MA_SV) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Thêm cột điểm vào bảng SV_LHP_DTP
ALTER TABLE SV_LHP_DTP
ADD diem DECIMAL(5, 2);

INSERT INTO CoSo (id_CS, TEN_CS, DIA_CHI) VALUES
('CS001', 'Cơ Sở A', N'Hà Nội, Việt Nam'),
('CS002', 'Cơ Sở B', N'TP.HCM, Việt Nam'),
('CS003', 'Cơ Sở C', N'Đà Nẵng, Việt Nam'),
('CS004', 'Cơ Sở D', N'Hải Phòng, Việt Nam'),
('CS005', 'Cơ Sở E', N'Cần Thơ, Việt Nam');

-- Chèn dữ liệu vào bảng Khu
INSERT INTO Khu (id_KHU, TEN_KHU, id_CS) VALUES
('KHU001', 'Khu A', 'CS001'),
('KHU002', 'Khu B', 'CS002'),
('KHU003', 'Khu C', 'CS003'),
('KHU004', 'Khu D', 'CS004'),
('KHU005', 'Khu E', 'CS005');

-- Chèn dữ liệu vào bảng Phòng
INSERT INTO Phong (MA_PHONG, TEN_PHONG, id_KHU, SO_LG) VALUES
('PH001', N'Phòng 101', 'KHU001', 30),
('PH002', N'Phòng 102', 'KHU001', 25),
('PH003', N'Phòng 201', 'KHU002', 20),
('PH004', N'Phòng 202', 'KHU003', 40),
('PH005', N'Phòng 301', 'KHU004', 35);

-- Chèn dữ liệu vào bảng Chức Vụ
INSERT INTO ChucVu (ID_CHUC_VU, TEN_CV) VALUES
('CV001', N'Giảng viên'),
('CV002', N'Trợ giảng'),
('CV003', N'Quản lý lớp'),
('CV004', N'Cán bộ lớp'),
('CV005', N'Thư ký');

-- Chèn dữ liệu vào bảng Khoa
INSERT INTO Khoa (MA_KHOA, Ten_Khoa) VALUES
('KHOA001', N'Khoa Công nghệ Thông tin'),
('KHOA002', N'Khoa Toán'),
('KHOA003', N'Khoa Vật lý'),
('KHOA004', N'Khoa Hóa học'),
('KHOA005', N'Khoa Sinh học');

-- Chèn dữ liệu vào bảng Lớp Sinh Hoạt
INSERT INTO LopSinhHoat (ID_LSH, TEN_LSH) VALUES
('LSH001', N'Lớp A1'),
('LSH002', N'Lớp B1'),
('LSH003', N'Lớp C1'),
('LSH004', N'Lớp D1'),
('LSH005', N'Lớp E1');

-- Chèn dữ liệu vào bảng Sinh Viên
INSERT INTO SinhVien (MA_SV, TenSV, MA_KHOA, MA_LSH) VALUES
('SV001', N'Nguyễn Văn A', 'KHOA001', 'LSH001'),
('SV002', N'Trần Thị B', 'KHOA002', 'LSH002'),
('SV003', N'Lê Văn C', 'KHOA003', 'LSH003'),
('SV004', N'Phan Thị D', 'KHOA004', 'LSH004'),
('SV005', N'Vũ Thị E', 'KHOA005', 'LSH005');

-- Cập nhật thông tin Cán Bộ Lớp
INSERT INTO CanBoLop (id_SV, id_LSH, id_CV, Ngay_BD, Ngay_KT) VALUES
('SV001', 'LSH001', 'CV001', '2024-09-01', '2025-06-01'),
('SV002', 'LSH002', 'CV002', '2024-09-01', '2025-06-01'),
('SV003', 'LSH003', 'CV003', '2024-09-01', '2025-06-01'),
('SV004', 'LSH004', 'CV004', '2024-09-01', '2025-06-01'),
('SV003', 'LSH003', 'CV005', '2025-06-02', '2026-06-01');  -- Không chồng chéo

-- Chèn dữ liệu vào bảng Giảng Viên
INSERT INTO GiangVien (MA_GV, TEN_GV) VALUES
('GV001', N'Đặng Văn A'),
('GV002', N'Nguyễn Thị B'),
('GV003', N'Lê Văn C'),
('GV004', N'Trần Thị D'),
('GV005', N'Vũ Minh E');

-- Chèn dữ liệu vào bảng Chủ Nhiệm
INSERT INTO ChuNhiem (ID_GV, MA_LSH, NGAY_BD, NGAY_KT) VALUES
('GV001', 'LSH001', '2024-09-01', '2025-06-01'),
('GV002', 'LSH002', '2024-09-01', '2025-06-01'),
('GV003', 'LSH003', '2025-06-02', '2026-06-01'),  -- Không chồng chéo
('GV004', 'LSH004', '2024-09-01', '2025-06-01'),
('GV005', 'LSH005', '2024-09-01', '2025-06-01');

-- Chèn dữ liệu vào bảng Học Kỳ
INSERT INTO HocKy (MA_HK, TEN_HK, TG_BD, TG_KT) VALUES
('HK001', N'Học kỳ 1', '2024-09-01', '2025-01-15'),
('HK002', N'Học kỳ 2', '2025-02-01', '2025-06-15'),
('HK003', N'Học kỳ 3', '2025-07-01', '2025-11-15'),
('HK004', N'Học kỳ hè', '2025-06-20', '2025-08-20'),
('HK005', N'Học kỳ 4', '2025-09-01', '2026-01-15');

-- Chèn dữ liệu vào bảng Học Phần
INSERT INTO HocPhan (MA_HP, TEN_HP, SO_TC) VALUES
('HP001', N'Lập trình C', 3),
('HP002', N'Toán cao cấp', 2),
('HP003', N'Hóa đại cương', 4),
('HP004', N'Vật lý cơ bản', 3),
('HP005', N'Sinh học đại cương', 2);

-- Chèn dữ liệu vào bảng Lớp Học Phần
INSERT INTO LopHP (MA_LHP, MA_HP, MA_HK, MA_PHONG, THU, TIET_BD, MA_GV, Ngay_HL) VALUES
('LHP001', 'HP001', 'HK001', 'PH001', N'Thứ 2', 8, 'GV001', '2024-09-01'),
('LHP002', 'HP002', 'HK001', 'PH002', N'Thứ 3', 9, 'GV002', '2024-09-01'),
('LHP003', 'HP003', 'HK002', 'PH003', N'Thứ 4', 10, 'GV003', '2025-01-01'),
('LHP004', 'HP004', 'HK002', 'PH004', N'Thứ 5', 11, 'GV004', '2025-01-01'),
('LHP005', 'HP005', 'HK003', 'PH005', N'Thứ 6', 12, 'GV005', '2025-06-01');

-- Chèn thêm Lớp Học Phần
INSERT INTO LopHP (MA_LHP, MA_HP, MA_HK, MA_PHONG, THU, TIET_BD, MA_GV, Ngay_HL) VALUES
('LHP006', 'HP001', 'HK003', 'PH005', N'Thứ 2', 1, 'GV001', '2025-06-01');

-- Chèn dữ liệu vào bảng SV_LHP
INSERT INTO SV_LHP (id_SV, id_LHP) VALUES
('SV001', 'LHP001'),
('SV002', 'LHP002'),
('SV003', 'LHP003'),
('SV004', 'LHP004'),
('SV005', 'LHP005');

-- Chèn dữ liệu vào bảng Điểm Thành Phần
INSERT INTO DIEM_TP (idDTP, tenDTP) VALUES
('DTP01', N'Điểm giữa kỳ'),
('DTP02', N'Điểm cuối kỳ'),
('DTP03', N'Điểm thực hành'),
('DTP04', N'Điểm kiểm tra'),
('DTP05', N'Điểm chuyên cần');

-- Chèn dữ liệu vào bảng LHP_DTP
INSERT INTO LHP_DTP (idLHP, maDTP, heSo) VALUES
('LHP001', 'DTP01', 0.3),
('LHP001', 'DTP02', 0.5),
('LHP002', 'DTP03', 0.4),
('LHP003', 'DTP04', 0.2),
('LHP004', 'DTP05', 0.1);

-- Chèn dữ liệu vào bảng SV_LHP_DTP
INSERT INTO SV_LHP_DTP (idSV, idLHP, idDTP) VALUES
('SV001', 'LHP001', 'DTP01'),
('SV001', 'LHP001', 'DTP02'),
('SV002', 'LHP002', 'DTP03'),
('SV003', 'LHP003', 'DTP04'),
('SV004', 'LHP004', 'DTP05'),
('SV005', 'LHP005', 'DTP01');

-- Cập nhật điểm cho SV001
UPDATE SV_LHP_DTP
SET diem = 8.5
WHERE idSV = 'SV001' AND idLHP = 'LHP001' AND idDTP = 'DTP01';

UPDATE SV_LHP_DTP
SET diem = 9.0
WHERE idSV = 'SV001' AND idLHP = 'LHP001' AND idDTP = 'DTP02';

-- Cập nhật điểm cho SV002
UPDATE SV_LHP_DTP
SET diem = 7.0
WHERE idSV = 'SV002' AND idLHP = 'LHP002' AND idDTP = 'DTP03';

-- Cập nhật điểm cho SV003
UPDATE SV_LHP_DTP
SET diem = 6.5
WHERE idSV = 'SV003' AND idLHP = 'LHP003' AND idDTP = 'DTP04';

-- Cập nhật điểm cho SV004
UPDATE SV_LHP_DTP
SET diem = 8.0
WHERE idSV = 'SV004' AND idLHP = 'LHP004' AND idDTP = 'DTP05';

-- Cập nhật điểm cho SV005
UPDATE SV_LHP_DTP
SET diem = 7.5
WHERE idSV = 'SV005' AND idLHP = 'LHP005' AND idDTP = 'DTP01';

--1. Lấy danh sách tất cả các lớp học phần được giảng dạy trong 'Học kỳ 1' cùng với tên giảng viên.
SELECT MA_LHP,
       (SELECT TEN_HP FROM HocPhan WHERE HocPhan.MA_HP = LopHP.MA_HP) AS TEN_HP,
       (SELECT TEN_HK FROM HocKy WHERE HocKy.MA_HK = LopHP.MA_HK) AS TEN_HK,
       (SELECT TEN_GV FROM GiangVien WHERE GiangVien.MA_GV = LopHP.MA_GV) AS TEN_GV
FROM LopHP
WHERE MA_HK = 'HK001';

--2.Tìm tất cả các phòng có sức chứa lớn hơn 30 sinh viên
SELECT * FROM Phong
WHERE SO_LG > 30;

--3.Liệt kê tất cả các sinh viên là cán bộ lớp, cùng với tên lớp và chức vụ của họ
SELECT 
    sv.MA_SV,
    sv.TenSV,
    lsh.TEN_LSH,
    cv.TEN_CV,
    cl.Ngay_BD AS Ngay_Hieu_Luc,
    cl.Ngay_KT AS Ngay_KetThuc
FROM 
    CanBoLop cl
JOIN 
    SinhVien sv ON cl.id_SV = sv.MA_SV
JOIN 
    LopSinhHoat lsh ON cl.id_LSH = lsh.ID_LSH
JOIN 
    ChucVu cv ON cl.id_CV = cv.ID_CHUC_VU;

--4.Đếm Số Sinh Viên Trong Mỗi Khoa

SELECT k.Ten_Khoa, COUNT(s.MA_SV) AS So_SV
FROM SinhVien s
JOIN Khoa k ON s.MA_KHOA = k.MA_KHOA
GROUP BY k.Ten_Khoa;

--5.Lấy Danh Sách Giảng Viên và Các Lớp Sinh Hoạt Họ Chủ Nhiệm

SELECT g.TEN_GV, l.TEN_LSH
FROM GiangVien g, ChuNhiem c, LopSinhHoat l
WHERE g.MA_GV = c.ID_GV AND c.MA_LSH = l.ID_LSH;

--6.Lấy Tất Cả Các Lớp Học Phần và Tên Giảng Viên Tương Ứng

SELECT l.MA_LHP, hp.TEN_HP, gv.TEN_GV
FROM LopHP l, HocPhan hp, GiangVien gv
WHERE l.MA_HP = hp.MA_HP AND l.MA_GV = gv.MA_GV;

--7.Tính tổng số tín chỉ của tất cả các học phần mà sinh viên đã đăng ký, nhóm theo sinh viên và sắp xếp giảm dần theo tổng số tín chỉ

SELECT id_SV, SUM(HocPhan.SO_TC) AS Tong_TC 
FROM SV_LHP
JOIN LopHP ON SV_LHP.id_LHP = LopHP.MA_LHP
JOIN HocPhan ON LopHP.MA_HP = HocPhan.MA_HP
GROUP BY id_SV
ORDER BY Tong_TC DESC;

--8.Liệt kê các lớp học phần (LopHP) có hơn 2 sinh viên đăng ký, sắp xếp theo mã lớp học phần

SELECT id_LHP, COUNT(id_SV) AS SoLuongSV 
FROM SV_LHP
GROUP BY id_LHP
HAVING COUNT(id_SV) > 2
ORDER BY id_LHP;

--9.Tìm danh sách các lớp sinh hoạt có hơn 1 sinh viên là cán bộ lớp, nhóm theo mã lớp sinh hoạt và sắp xếp theo mã lớp sinh hoạt

SELECT LopSinhHoat.TEN_LSH, COUNT(CanBoLop.id_SV) AS SoLuongCanBo
FROM CanBoLop
JOIN LopSinhHoat ON CanBoLop.id_LSH = LopSinhHoat.ID_LSH
GROUP BY LopSinhHoat.TEN_LSH
HAVING COUNT(CanBoLop.id_SV) > 1
ORDER BY LopSinhHoat.TEN_LSH;

--10.tìm tên sinh viên và tên các học phần mà sinh viên đó đang học, cùng với tên giảng viên dạy học phần đó

SELECT SinhVien.TenSV, HocPhan.TEN_HP, GiangVien.TEN_GV
FROM SinhVien
JOIN SV_LHP ON SinhVien.MA_SV = SV_LHP.id_SV
JOIN LopHP ON SV_LHP.id_LHP = LopHP.MA_LHP
JOIN HocPhan ON LopHP.MA_HP = HocPhan.MA_HP
JOIN GiangVien ON LopHP.MA_GV = GiangVien.MA_GV;


--11.liệt kê tất cả các lớp học (LopHP) đang diễn ra trong một khoảng thời gian nhất định và tên của giảng viên dạy các lớp đó

SELECT LopHP.MA_LHP, HocPhan.TEN_HP, LopHP.THU, LopHP.TIET_BD, GiangVien.TEN_GV
FROM LopHP
JOIN HocPhan ON LopHP.MA_HP = HocPhan.MA_HP
JOIN GiangVien ON LopHP.MA_GV = GiangVien.MA_GV
WHERE LopHP.Ngay_HL BETWEEN '2025-01-01' AND '2025-12-31';

--12.Truy vấn điểm trung bình của sinh viên trong từng lớp học phần
SELECT 
    SV_LHP.id_LHP,
    AVG(SV_LHP_DTP.diem * LHP_DTP.heSo) AS DiemTrungBinh
FROM 
    SV_LHP
JOIN 
    SV_LHP_DTP ON SV_LHP.id_LHP = SV_LHP_DTP.idLHP
JOIN 
    LHP_DTP ON SV_LHP_DTP.idLHP = LHP_DTP.idLHP
GROUP BY 
    SV_LHP.id_LHP;

--13.Truy vấn thời khóa biểu của sinh viên 001

SELECT 
    LopHP.MA_LHP,
    HocPhan.TEN_HP,
    GiangVien.TEN_GV,
    LopHP.THU,
    LopHP.TIET_BD,
    (LopHP.TIET_BD + HocPhan.SO_TC - 1) AS TIET_KT,
    LopHP.Ngay_HL
FROM 
    SV_LHP
JOIN 
    LopHP ON SV_LHP.id_LHP = LopHP.MA_LHP
JOIN 
    HocPhan ON LopHP.MA_HP = HocPhan.MA_HP
JOIN 
    GiangVien ON LopHP.MA_GV = GiangVien.MA_GV
WHERE 
    SV_LHP.id_SV = 'SV001';
--Thêm lớp học phần 006 vào cho sinh viên 001
BEGIN TRANSACTION;

INSERT INTO SV_LHP (id_SV, id_LHP) VALUES ('SV001', 'LHP006');

-- Kiểm tra kết quả trước khi commit
SELECT * FROM SV_LHP WHERE id_SV = 'SV001';

-- Nếu mọi thứ đều ổn, hãy commit
--COMMIT;

-- Nếu bạn muốn hoàn tác, hãy uncomment dòng dưới đây
 --ROLLBACK;

--Cập nhật điểm thành phần số 1 của học phần 001 cho sinh viên 001 thành 9.5
UPDATE SV_LHP_DTP
SET diem = 9.5
WHERE idSV = 'SV001' AND idLHP = 'LHP001' AND idDTP = 'DTP01';
SELECT * FROM SV_LHP_DTP WHERE idSV = 'SV001' AND idLHP = 'LHP001';

-----------------------------------------------------Delete-----------------------------------------------

--1.Xóa sinh  viên 005
DELETE FROM SinhVien
WHERE MA_SV = 'SV005';

--2.Xóa những lớp học phần có ít hơn 3 sinh viên đăng kí
DELETE FROM LopHP
WHERE MA_LHP IN (
    SELECT id_LHP
    FROM SV_LHP
    GROUP BY id_LHP
    HAVING COUNT(id_SV) < 3
);

--3.Xóa sinh viên chưa đăng kí lớp học phần nào
DELETE FROM SinhVien
WHERE MA_SV NOT IN (
    SELECT id_SV
    FROM SV_LHP
);

--4.Xóa tất cả các cán bộ lớp có ngày kết thúc (Ngay_KT) là trước '2025-01-01'.
DELETE FROM CanBoLop
WHERE Ngay_KT < '2025-01-01';

--5.Xóa giảng viên có mã giảng viên là 'GV003' và tất cả các bản ghi tương ứng trong bảng ChuNhiem.
DELETE FROM ChuNhiem
WHERE ID_GV = 'GV003';

DELETE FROM GiangVien
WHERE MA_GV = 'GV003';
------------------------------------Update-------------------------------------
--1. Đổi tên khoa mã KHOA001 thành Khoa công nghệ số
UPDATE Khoa
SET Ten_Khoa = N'Khoa Công nghệ số'
WHERE MA_KHOA = 'KHOA001';

--2. Cập nhật tên lớp học có mã ‘LSH001’ thành tên ‘Lớp Khoa học máy tính 23T1’
UPDATE LopSinhHoat
SET TEN_LSH = N'Lớp Khoa học máy tính 23T1'
WHERE ID_LSH = 'LSH001';

--3. Cập nhật thời gian bắt đầu của học kì có mã HK123 là "20-09-2024"
UPDATE HocKy
SET TG_BD = '2024-09-20'
WHERE MA_HK = 'HK001';

--4. Cập nhật số tín chỉ HP003 thành 3
UPDATE HocPhan
SET SO_TC = 3
WHERE MA_HP = 'HP003';

------------------------------------------------View-------------------------------------------------------
--1.Tạo view tách họ và tên lót của sinh viên
CREATE VIEW View_TenSV AS
SELECT 
    MA_SV,
    LEFT(TenSV, CHARINDEX(' ', TenSV) - 1) AS Ho,
    SUBSTRING(TenSV, CHARINDEX(' ', TenSV) + 1, LEN(TenSV)) AS TenLot
FROM 
    SinhVien
WHERE 
    CHARINDEX(' ', TenSV) > 0;

SELECT *
FROM View_TenSV;

--2.Tạo view lấy danh sách sinh viên và khoa tương ứng
CREATE VIEW View_SinhVien_Khoa AS
SELECT 
    sv.MA_SV,
    sv.TenSV,
    sv.MA_KHOA,
    k.Ten_Khoa
FROM 
    SinhVien sv
JOIN 
    Khoa k ON sv.MA_KHOA = k.MA_KHOA;
select * from View_SinhVien_Khoa

--3. Tạo View thông tin chi tiết của giảng viên và lớp sinh hoạt
CREATE VIEW View_GiangVien_Lop AS
SELECT 
    gv.MA_GV,
    gv.TEN_GV,
    l.ID_LSH,
    l.TEN_LSH
FROM 
    GiangVien gv
JOIN 
    ChuNhiem c ON gv.MA_GV = c.ID_GV
JOIN 
    LopSinhHoat l ON c.MA_LSH = l.ID_LSH;
select * from View_GiangVien_Lop
------------------------------------------------Hàm và thủ tục---------------------------------------------
--1./ Tạo thủ tục để thêm sinh viên
CREATE PROCEDURE pr_ThemSinhVien
    @MA_SV CHAR(5),
    @TenSV NVARCHAR(100),
    @MA_KHOA CHAR(7),
    @MA_LSH CHAR(6)
AS
BEGIN
    INSERT INTO SinhVien (MA_SV, TenSV, MA_KHOA, MA_LSH)
    VALUES (@MA_SV, @TenSV, @MA_KHOA, @MA_LSH);
END;
---gọi thủ tục
exec pr_ThemSinhVien 'SV006',N'Nguyễn Văn A','KHOA001','LSH003'

--2./Kiểm tra có tồn tại sinh viên với mã sinh viên nhất định 
CREATE FUNCTION fn_SVien_exists 
(
    @maSV CHAR(5)
)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @ketQua NVARCHAR(50);  -- Khai báo kiểu dữ liệu cho biến @ketQua

    IF EXISTS (SELECT 1 FROM SinhVien WHERE MA_SV = @maSV)
        SET @ketQua = N'Tìm thấy sinh viên mã ' + @maSV;  -- Thêm khoảng trắng
    ELSE
        SET @ketQua = N'Không tìm thấy sinh viên mã ' + @maSV;  -- Thêm khoảng trắng

    RETURN @ketQua;
END;
--Gọi hàm 
print dbo.fn_SVien_exists('SV006');

--3./Tạo hàm lấy danh sách lớp học phần của 1 sinh viên 
CREATE FUNCTION fn_LayDanhSachLHP (@MA_SV CHAR(5))
RETURNS TABLE
AS
RETURN
(
    SELECT LopHP.MA_LHP, HocPhan.TEN_HP
    FROM SV_LHP
    JOIN LopHP ON SV_LHP.id_LHP = LopHP.MA_LHP
    JOIN HocPhan ON LopHP.MA_HP = HocPhan.MA_HP
    WHERE SV_LHP.id_SV = @MA_SV
);
--gọi hàm
select * from dbo.fn_LayDanhSachLHP ('SV001');

--4./Viết thủ tục cập nhật thông tin cán bộ lớp
CREATE PROCEDURE CapNhatCanBoLop
    @id_SV CHAR(5),
    @id_LSH CHAR(6),
    @id_CV CHAR(5),
    @Ngay_BD DATE,
    @Ngay_KT DATE
AS
BEGIN
    UPDATE CanBoLop
    SET Ngay_BD = @Ngay_BD, Ngay_KT = @Ngay_KT
    WHERE id_SV = @id_SV AND id_LSH = @id_LSH AND id_CV = @id_CV;
END;
EXEC CapNhatCanBoLop 
    @id_SV = 'SV001',           -- Mã sinh viên
    @id_LSH = 'LSH001',        -- Mã lớp sinh hoạt
    @id_CV = 'CV001',          -- Mã chức vụ
    @Ngay_BD = '2024-09-01',   -- Ngày bắt đầu
    @Ngay_KT = '2025-06-01';   -- Ngày kết thúc

--Tạo hàm tính số tín chỉ 1 sinh viên đã đăng kí
CREATE FUNCTION fn_TongTinChi(@MA_SV CHAR(5))
RETURNS INTEGER
AS
BEGIN
    DECLARE @TongTC INTEGER;

    SELECT @TongTC = SUM(HocPhan.SO_TC)
    FROM SV_LHP
    JOIN LopHP ON SV_LHP.id_LHP = LopHP.MA_LHP
    JOIN HocPhan ON LopHP.MA_HP = HocPhan.MA_HP
    WHERE SV_LHP.id_SV = @MA_SV;

    RETURN @TongTC;
END;
SELECT dbo.fn_TongTinChi('SV001') AS TongSoTinChi;

--Tạo hàm lấy tên khoa từ mã khoa
CREATE FUNCTION fn_LayTenKhoa(@MA_KHOA CHAR(7))
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @TEN_KHOA NVARCHAR(100);

    SELECT @TEN_KHOA = Ten_Khoa
    FROM Khoa
    WHERE MA_KHOA = @MA_KHOA;

    RETURN @TEN_KHOA;
END;
SELECT dbo.fn_LayTenKhoa('KHOA001') AS TenKhoa;

--tạo thủ tục lấy danh sách sinh viên từ lớp sinh hoạt
CREATE PROCEDURE pr_LayDanhSachSinhVien
    @MA_LSH CHAR(6)
AS
BEGIN
    SELECT 
        sv.MA_SV,
        sv.TenSV
    FROM 
        SinhVien sv
    JOIN 
        LopSinhHoat lsh ON sv.MA_LSH = lsh.ID_LSH
    WHERE 
        lsh.ID_LSH = @MA_LSH;
END;
EXEC pr_LayDanhSachSinhVien 'LSH001';

--tạo thủ tục cập nhật sinh viên
CREATE PROCEDURE pr_CapNhatThongTinSinhVien
    @MA_SV CHAR(5),
    @TenSV NVARCHAR(100),
    @MA_KHOA CHAR(7),
    @MA_LSH CHAR(6)
AS
BEGIN
    UPDATE SinhVien
    SET 
        TenSV = @TenSV,
        MA_KHOA = @MA_KHOA,
        MA_LSH = @MA_LSH
    WHERE 
        MA_SV = @MA_SV;
END;
EXEC pr_CapNhatThongTinSinhVien 'SV001', N'Nguyễn Văn A', 'KHOA001', 'LSH001';
--------------------------------------------------Trigger---------------------------------------------------------------
--5./Tạo trigger ghi lại những sinh viên được thêm mới
-- Tạo bảng Log để lưu trữ thông tin log
CREATE TABLE Log_SinhVien (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MA_SV CHAR(5),
    Ngay_Ghi DATETIME DEFAULT GETDATE()
);

-- Tạo Trigger lưu trữ danh sách các sinh viên mới được thêm vào
CREATE TRIGGER trg_AfterInsert_SinhVien
ON SinhVien
AFTER INSERT
AS
BEGIN
    INSERT INTO Log_SinhVien (MA_SV)
    SELECT MA_SV FROM inserted;  -- Lấy mã sinh viên từ bảng inserted
END;
--gọi thủ tục thêm sinh viên để kích hoạt trigger 
exec pr_ThemSinhVien 'SV007',N'Trần Văn F','KHOA002','LSH001'

--viết trigger thay thế On delete Cascade
CREATE TRIGGER trg_LopSinhHoat_Delete
ON LopSinhHoat
AFTER DELETE
AS
BEGIN
    DELETE FROM CanBoLop 
    WHERE id_LSH IN (SELECT ID_LSH FROM deleted);
END;
--loại bỏ khóa ngoại bị bắt cầu
alter table CanBoLop
drop constraint FK__CanBoLop__id_LSH__49C3F6B7
--thử dữ liệu
select * from CanBoLop
select * from LopSinhHoat;
--thêm data mẫu
insert into LopSinhHoat
values ('LSH006',N'Lớp F1');
insert into CanBoLop
values ('SV001','LSH006','CV002','2025-06-01','2025-07-01');
--test trigger
delete from LopSinhHoat
where ID_LSH ='LSH006';

--viết trigger thay thế On update Cascade
CREATE TRIGGER trg_LopSinhHoat_Update
ON LopSinhHoat
AFTER UPDATE
AS
BEGIN
    UPDATE CanBoLop 
    SET id_LSH = i.ID_LSH
    FROM CanBoLop c
    INNER JOIN inserted i ON c.id_LSH = i.ID_LSH;
END;
