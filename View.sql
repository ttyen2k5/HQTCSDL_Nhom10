USE QUANLYBENHNHAN

GO
-- --View thông tin bệnh nhân
-- CREATE VIEW v_ThongTinBenhNhan AS
-- SELECT 
--   bn.BenhNhanID AS IDBenhNhan,
--   bn.HoTen AS HoTenBenhNhan,
--   dbo.TinhTuoi(bn.BenhNhanID) AS Tuoi,
--   bs.BacSiID AS IDBacSi,
--   bs.HoTen AS TenBacSi,
--   k.TenKhoa AS KhoaTrucThuoc,
--   hs.ChanDoan AS ChuanDoanBenh,
--   bl.TongTien AS TongTien
-- FROM 
--   BenhNhan bn
--   LEFT JOIN HoSoBenhAn hs ON bn.BenhNhanID = hs.BenhNhanID
--   LEFT JOIN BacSi bs ON hs.BacSiID = bs.BacSiID
--   LEFT JOIN Khoa k ON bs.KhoaID = k.KhoaID
--   LEFT JOIN BienLai bl ON hs.HoSoID = bl.HoSoID;
-- GO
GO
--View thông tin bệnh nhân
CREATE VIEW v_ThongTinBenhNhan AS
SELECT 
  BenhNhan.BenhNhanID AS IDBenhNhan,
  BenhNhan.HoTen AS HoTenBenhNhan,
  dbo.TinhTuoi(bn.BenhNhanID) AS Tuoi,
  BacSi.BacSiID AS IDBacSi,
  BacSi.HoTen AS TenBacSi,
  TenKhoa AS KhoaTrucThuoc,
  ChanDoan AS ChuanDoanBenh,
  TongTien AS TongTien
FROM 
  BenhNhan, HoSoBenhAn, BacSi, Khoa, BienLai
WHERE 
	BenhNhan.BenhNhanID = HoSoBenhAn.BenhNhanID and
	HoSoBenhAn.BacSiID = BacSi.BacSiID and 
	BacSi.KhoaID = Khoa.KhoaID and 
	HoSoBenhAn.HoSoID = BienLai.HoSoID;
GO



SELECT * FROM v_ThongTinBenhNhan



GO
--view thống kê số lượng bệnh nhân xuất viện theo tháng
CREATE VIEW v_ThongKeSoLuongXuatVienTheoThang AS
SELECT 
  YEAR(NgayXuatVien) AS Nam,
  MONTH(NgayXuatVien) AS Thang,
  COUNT(*) AS SoLuongXuatVien
FROM 
    BenhNhan
WHERE 
  NgayXuatVien IS NOT NULL -- Chỉ lấy những bệnh nhân đã xuất viện
GROUP BY 
  YEAR(NgayXuatVien),
  MONTH(NgayXuatVien);
GO

SELECT * FROM v_ThongKeSoLuongXuatVienTheoThang




GO
--view thống kê số lượng bệnh nhân nhập viện theo tháng
CREATE VIEW v_ThongKeSoLuongNhapVienTheoThang AS
SELECT 
  YEAR(NgayNhapVien) AS Nam,
  MONTH(NgayNhapVien) AS Thang,
  COUNT(*) AS SoLuongNhapVien
FROM 
  BenhNhan
WHERE 
  NgayNhapVien IS NOT NULL -- Chỉ lấy những bệnh nhân đã nhập viện
GROUP BY 
  YEAR(NgayNhapVien),
  MONTH(NgayNhapVien);
GO



SELECT * FROM v_ThongKeSoLuongNhapVienTheoThang

