--1:
SELECT *
FROM HangSX, SanPham;

--2:
INSERT INTO NhanVien(MaNV, TenNV, GioiTinh, DiaChi, SoDT, TenPhong)
VALUES ('100', N'Nguyễn Phúc Cường', 'Nam', 'Bac Kan', '0799233090', 'abc');

--3:
UPDATE NhanVien
SET SoDT = '023456789'
WHERE MaNV = '100';

--4:
SELECT MaNV, UPPER(TenNV) AS [Ten khach hang], DiaChi
FROM NhanVien
WHERE DiaChi = N'Hà Nội';

--5:
SELECT NhanVien.MaNV, COUNT(MaNV)
FROM NhanVien
GROUP BY NhanVien.MaNV;

--6:
SELECT MaNV, Ho + ' ' + Ten, ChucDanh, Luong, MaPhong, MaNguoiQL
FROM NhanVien
WHERE (MaPhong BETWEEN 30 AND 39) AND (MaNguoiQL = '3')
ORDER BY Luong

--7:
SELECT KH.MaKh, KH.TenKh, NV.Ho, NV.Ten
FROM NhanVien AS NV
INNER JOIN KhachHang AS KH
ON NV.MaNV = KH.MaNV
GROUP BY KH.Ten DESC;

--8:
SELECT NV.MaNV, (NV.Ho + ' ' + NV.Ten) [Họ tên], COUNT(MaKh)
FROM NhanVien AS NV
INNER JOIN KhachHang AS KH
ON NV.MaNV = KH.MaNV
GROUP BY NV.MaNV
HAVING COUNT(MaKh) >= 2

--9:
SELECT DISTINCT NV.MaNV, NV.Ho, NV.Ten, NV.Luong, NV.Thuong, (NV.Luong + NV.Luong*NV.Thuong) AS [Tổng lương]
WHERE KH.QuocGia = 'Việt Nam'
FROM NhanVien AS NV
INNER JOIN KhachHang AS KH
ON NV.MaNV = KH.MaNV

--10:
SELECT (NV.Ho + ' ' + UPPER(NV.Ten)) [Họ tên], NV.NgayBD [Ngày vào công ty], (YEAR(GETDATE()) - YEAR(NV.NgayBD)) [Số năm công tác],			--(DATEDIFF(yy,NV.NgayBD, GETDATE())) [Số năm công tác]
FROM NhanVien AS NV
INNER JOIN KhachHang AS KH
ON NV.MaNV = KH.MaNV
WHERE MONTH(NV.NgayBD) = 10
ORDER BY NV.NgayBD