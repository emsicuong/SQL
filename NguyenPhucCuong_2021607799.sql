--Cau 1:


USE master

GO 
	--Kiểm tra sụ tồn tại của CSDL 'DaoTaoDB'
	IF EXISTS(SELECT * FROM sys.databases WHERE name = 'DaoTaoDB')
	--Nếu tồn tại thì xóa bản cũ 
	DROP DATABASE DaoTaoDB

GO
--a:

CREATE DATABASE DaoTaoDB		--Tạo CSDL 

GO
USE DaoTaoDB

GO
--b:

CREATE TABLE SV(
	MaSV CHAR(10) PRIMARY KEY,
	Ho NVARCHAR(20),
	Ten NVARCHAR(20),
	TenLop NVARCHAR(50)
);

CREATE TABLE MON(
	MaMH CHAR(10) PRIMARY KEY,	
	TenMH NVARCHAR(30),
	SoTC INT
);

CREATE TABLE KQ(
	MaSV CHAR(10),
	MaMH CHAR(10),
	Diem INT
	PRIMARY KEY(MaSV, MaMH),
	FOREIGN KEY (MaSV) REFERENCES SV(MaSV),
	FOREIGN KEY (MaMH) REFERENCES MON(MaMH)
);

GO
--c:

INSERT INTO SV VALUES 
('001', N'Nguyễn Phúc', N'Cường', 'CNTT7'),
('002', N'Võ Mạnh', N'Cường', 'CNTT5'),
('003', N'Đào Xuân', N'Phượng', 'CNTT5')

INSERT INTO MON VALUES
('M123', N'Cơ sở dữ liệu', 4),
('M124', N'Toán rời rạc', 3),
('M125', N'Lập trình hướng đối tượng', 4)

INSERT INTO KQ VALUES
('001', 'M123', 9),
('002', 'M123', 5),
('001', 'M124', 8),
('003', 'M125', 6),
('003', 'M124', 7),
('001', 'M125', 8)

GO
--d:

SELECT * FROM SV;
SELECT * FROM MON;
SELECT * FROM KQ;

GO 
--e:

UPDATE MON
SET SoTC = 3
WHERE SoTC = 4


--Cau 2:

--a:

SELECT Ho, Ten
FROM SV
WHERE Ten LIKE '%a%'


--b:
SELECT SV.MaSV, SV.Ho, SV.Ten, KQ.Diem 
FROM SV
	INNER JOIN KQ
	ON SV.MaSV = KQ.MaSV
WHERE KQ.MaMH = 'M123' AND KQ.Diem >= 7

--c:
SELECT MON.TenMH, COUNT(SV.MaSV) [Số sinh viên đã học]
FROM ((MON
	INNER JOIN KQ
	ON MON.MaMH = KQ.MaMH)
	INNER JOIN SV
	ON SV.MaSV = KQ.MaSV)
WHERE SV.TenLop = 'CNTT5'
GROUP BY MON.TenMH

--d:
SELECT SV.MaSV, SV.Ho + ' ' + SV.Ten [Họ tên], MON.TenMH, AVG(KQ.Diem) [Điểm trung bình]
FROM ((MON
	INNER JOIN KQ
	ON MON.MaMH = KQ.MaMH)
	INNER JOIN SV
	ON SV.MaSV = KQ.MaSV)
GROUP BY SV.MaSV, SV.Ho, SV.Ten, MON.TenMH
HAVING AVG(KQ.Diem) >= 8

--e
SELECT MON.TenMH
FROM MON
	INNER JOIN KQ
	ON MON.MaMH = KQ.MaMH
WHERE KQ.Diem = (SELECT KQ.Diem
	FROM KQ
	WHERE KQ.Diem = 10
)
