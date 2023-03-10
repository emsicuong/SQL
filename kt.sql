USE master

CREATE DATABASE QuanLyHocTap

USE QuanLyHocTap

GO
CREATE TABLE SV(
	MaSV CHAR(10) PRIMARY KEY,
	Ho NVARCHAR(20),
	Ten NVARCHAR(30),
	TenLop NVARCHAR(50)
)

CREATE TABLE MON(
	MaMH CHAR(10) PRIMARY KEY,
	TenMH NVARCHAR(10),
	SoTC INT
)

CREATE TABLE KQ(
	MaSV CHAR(10) NOT NULL,
	MaMH CHAR(10) NOT NULL,
	Diem INT,
	PRIMARY KEY(MaSV, MaMH),
	FOREIGN KEY(MaSV) REFERENCES SV(MaSV),
	FOREIGN KEY(MaMH) REFERENCES MON(MaMH)
)


INSERT INTO SV VALUES 
('sv01', N'Nguyễn Phúc', N'Cường', 'IT07'),
('sv02', N'Nguyễn Thị', N'Hoa', 'IT06'),
('sv03', N'Lê Thu', N'Hà', 'IT07')


INSERT INTO MON VALUES
('IT0010', N'CSDL', 4),
('IT0011', N'OOP', 4),
('IT0012', N'TRR', 2)

INSERT INTO KQ VALUES
('sv01', 'IT0012', 10),
('sv01', 'IT0011', 9),
('sv01', 'IT0010', 10),
('sv02', 'IT0010', 4),
('sv03', 'IT0011', 5),
('sv03', 'IT0012', 9)

INSERT INTO KQ VALUES
('sv02', 'IT0011', 3),
('sv02', 'IT0012', 4)


SELECT * FROM SV
SELECT * FROM MON
SELECT * FROM KQ

GO

--e)
UPDATE MON
SET SoTC = 3
WHERE SoTC = 4



--Cau2:

--a)
SELECT Ten 
FROM SV
WHERE Ten LIKE 'H%'

--b)
--Cach 1:
SELECT SV.Ten 
FROM KQ
	INNER JOIN SV
		ON SV.MaSV = KQ.MaSV
	INNER JOIN MON
		ON KQ.MaMH = MON.MaMH
WHERE MON.TenMH = N'CSDL' AND KQ.Diem >= 7

--Cach 2:
SELECT Ten
FROM SV
WHERE MaSV = (SELECT MaSV
			FROM KQ
			WHERE Diem >= 7 AND MaMH = (SELECT MaMH
									FROM MON
									WHERE TenMH = N'CSDL'))


--c)
SELECT MaMH, COUNT(MaSV) [Số sinh viên đã học]
FROM KQ
GROUP BY MaMH

--d)
SELECT TenMH
FROM MON
WHERE SoTC = (SELECT MAX(SoTC)
			FROM MON)



---Cau2:

--a) 
SELECT SV.Ten, MON.TenMH, MON.SoTC, KQ.Diem
FROM ((KQ
	INNER JOIN MON
	ON KQ.MaMH = MON.MaMH)
	INNER JOIN SV
	ON SV.MaSV = KQ.MaSV)

--b)
SELECT SV.MaSV, SV.Ten
FROM KQ
	INNER JOIN SV
	ON KQ.MaSV = SV.MaSV
WHERE KQ.MaMH = 'IT0012'

--c)
SELECT MON.MaMH, MON.TenMH
FROM KQ
INNER JOIN MON
	ON KQ.MaMH = MON.MaMH
WHERE KQ.Diem < 5

--d)
SELECT SV.Ten, MON.TenMH
FROM ((KQ
INNER JOIN MON
	ON KQ.MaMH = MON.MaMH)
INNER JOIN SV
	ON SV.MaSV = KQ.MaSV)
WHERE MON.SoTC < 4 AND KQ.Diem >= 7

--e)
SELECT SV.Ten
FROM SV	
WHERE NOT EXISTS (SELECT 1
				FROM KQ
				WHERE SV.MaSV = KQ.MaSV AND KQ.Diem < 5)


--f)
SELECT DISTINCT MON.TenMH
FROM KQ
INNER JOIN MON
	ON KQ.MaMH = MON.MaMH
WHERE NOT EXISTS(SELECT 1
				FROM KQ
				WHERE KQ.MaMH = MON.MaMH AND KQ.Diem = 10)


--g)
SELECT MaMH, TenMH, SoTC
FROM MON
WHERE SoTC > 2


--h)
SELECT SV.Ten, MON.TenMH, KQ.Diem
FROM ((KQ
	INNER JOIN SV
		ON KQ.MaSV = SV.MaSV)
	INNER JOIN MON
		ON KQ.MaMH = MON.MaMH)
WHERE MON.TenMH = 'CSDL'


--i)
SELECT SV.MaSV, SV.Ten, ROUND((SUM(KQ.Diem * MON.SoTC)/SUM(MON.SoTC)),3) [Điểm trung bình]
FROM ((KQ
	INNER JOIN SV
		ON KQ.MaSV = SV.MaSV)
	INNER JOIN MON
		ON KQ.MaMH = MON.MaMH)
GROUP BY SV.MaSV, SV.Ten


--j)
SELECT SV.MaSV, SV.Ten
FROM SV
WHERE EXISTS (SELECT 1
			FROM KQ 
				INNER JOIN MON
					ON KQ.MaMH = MON.MaMH
			WHERE SV.MaSV = KQ.MaSV AND KQ.Diem < 5 
			GROUP BY MON.MaMH, MON.TenMH
			HAVING COUNT(1) = COUNT(DISTINCT MON.MaMH))


SELECT DISTINCT SV.MaSV, SV.Ten
FROM ((KQ
	INNER JOIN SV
		ON KQ.MaSV = SV.MaSV)
	INNER JOIN MON
		ON KQ.MaMH = MON.MaMH)
WHERE KQ.Diem < 5
GROUP BY SV.MaSV, SV.Ten, MON.MaMH
HAVING COUNT(MON.MaMH) = COUNT(DISTINCT MON.MaMH)


--k)
SELECT SV.MaSV
FROM SV
GROUP BY SV.MaSV
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
				   FROM (SELECT COUNT(*)
						 FROM KQ
							INNER JOIN SV
								ON KQ.MaSV = SV.MaSV
						 GROUP BY KQ.MaSV)
				   )


SELECT TOP 1 SV.MaSV
FROM KQ
	INNER JOIN SV
		ON KQ.MaSV = SV.MaSV
WHERE KQ.Diem < 5
GROUP BY SV.MaSV
ORDER BY COUNT(*) DESC


