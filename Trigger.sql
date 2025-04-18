USE QUANLYBENHNHAN

--Trigger tự động cập nhật số lượng giường trống 
GO
CREATE TRIGGER trg_UpdateSoLuongGiuongTrong ON BenhNhan AFTER INSERT
AS
BEGIN
  UPDATE Phong SET GiuongTrong = GiuongTrong - 1
  FROM Phong
  WHERE PhongID = (SELECT PhongID FROM inserted)
END
GO

-- Check
SELECT * FROM Phong
INSERT INTO BenhNhan (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, NgayNhapVien, PhongID, BaoHiemID) VALUES (N'Lê Hải Lâm', '2004-09-01', N'Nam', N'88 Giáp Nhị, Hà Nội', '0912567890', '2021-02-15', 1, 1);
-- ok







-- Tự động cập nhật tổng tiền trong biên lai khi có dịch vụ được tạo mới
GO
CREATE TRIGGER trg_UpdateTongTienBienLai_AfterInsertDichVu ON DichVu AFTER INSERT
AS
BEGIN
  UPDATE BienLai 
  SET TongTien = COALESCE(TongTien, 0) + 
    (
		SELECT 
			SUM(Inserted.SoLan * LoaiDichVuKham.GiaDichVu * (1 - ISNULL(BaoHiemYTe.MienGiam, 0)))
		FROM 
			Inserted, 
			LoaiDichVuKham, 
			BenhNhan, 
			BaoHiemYTe
		WHERE 
			Inserted.LoaiDichVuID = LoaiDichVuKham.LoaiDichVuID and
			Inserted.BenhNhanID = BenhNhan.BenhNhanID and
			BenhNhan.BaoHiemID = BaoHiemYTe.BaoHiemID and
			Inserted.BienLaiID = BienLai.BienLaiID
    )
  WHERE BienLai.BienLaiID IN (SELECT DISTINCT BienLaiID FROM inserted);
END;
GO

-- check 
SELECT * FROM BienLai
INSERT INTO DichVu (LoaiDichVuID, SoLan, BienLaiID, BenhNhanID) VALUES 
(1, 1, 1, 1),
(2, 2, 1, 1);
-- ok






-- -- trigger tự động cập nhật khi tạo đơn thuốc 
-- GO
-- CREATE TRIGGER trg_UpdateTongTienBienLai_AfterInsertDonThuoc ON DonThuoc AFTER INSERT
-- AS
-- BEGIN
--   UPDATE BienLai 
--   SET TongTien = COALESCE(TongTien, 0) + 
--     (
--       SELECT SUM(i.SoLuong * dt.GiaThuoc * (1 - ISNULL(bh.MienGiam, 0)))
--       FROM inserted i
--       LEFT JOIN Thuoc dt ON i.ThuocID = dt.ThuocID
--       LEFT JOIN BenhNhan bn ON i.BenhNhanID = bn.BenhNhanID
--       LEFT JOIN BaoHiemYTe bh ON bn.BaoHiemID = bh.BaoHiemID 
--       WHERE i.BienLaiID = BienLai.BienLaiID
--     )
--   WHERE BienLai.BienLaiID IN (SELECT DISTINCT BienLaiID FROM inserted);
-- END
-- GO


-- trigger tự động cập nhật khi tạo đơn thuốc 
GO
CREATE TRIGGER trg_UpdateTongTienBienLai_AfterInsertDonThuoc ON DonThuoc AFTER INSERT
AS
BEGIN
  UPDATE BienLai 
  SET TongTien = COALESCE(TongTien, 0) + 
    (
      SELECT SUM(Inserted.SoLuong * Thuoc.GiaThuoc * (1 - ISNULL(BaoHiemYTe.MienGiam, 0)))
      FROM Inserted,
	      Thuoc,
		    BenhNhan,
		    BaoHiemYTe
      WHERE
	          Inserted.ThuocID = Thuoc.ThuocID and
            Inserted.BenhNhanID = BenhNhan.BenhNhanID and
            BenhNhan.BaoHiemID = BaoHiemYTe.BaoHiemID and
            Inserted.BienLaiID = BienLai.BienLaiID
    )
  WHERE BienLai.BienLaiID IN (SELECT DISTINCT BienLaiID FROM inserted);
END
GO
