-- ========================================================
-- Tên dự án: SilverCare - Hệ thống quản lý chăm sóc người cao tuổi
-- Mục đích: Khởi tạo bảng Quản lý thuốc (Medicine) liên kết với bảng Hồ sơ Người cao tuổi (Resident)
-- Hệ quản trị cơ sở dữ liệu khuyên dùng: Microsoft SQL Server (MS SQL)
-- ========================================================

USE SilverCareDb;
GO

-- Tạo bảng Quản lý thuốc (Medicine) nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Medicine]') AND type in (N'U'))
BEGIN
    CREATE TABLE Medicine (
        Id INT IDENTITY(1,1) PRIMARY KEY,                         -- Khóa chính, ID tự tăng trong DB
        MedicineName NVARCHAR(150) NOT NULL,                      -- Tên thuốc (VD: Amlodipine 5mg, Metformin 500mg, ...)
        Dosage NVARCHAR(50) NOT NULL,                             -- Liều lượng (VD: 1 viên, 2 viên, 5ml, ...)
        ResidentId INT NOT NULL CONSTRAINT FK_Medicine_Resident FOREIGN KEY REFERENCES Resident(Id) ON DELETE CASCADE, -- Khóa ngoại liên kết bảng Resident (nguoicaotuoi.sql)
        ResidentName NVARCHAR(100) NOT NULL,                      -- Tên người cao tuổi (Lấy từ nguoicaotuoi.sql)
        ScheduleTime VARCHAR(100) NOT NULL,                       -- Khung giờ uống thuốc (VD: 08:00, 20:00; 07:00, 12:00, 19:00)
        Frequency NVARCHAR(50) NOT NULL,                          -- Tần suất (VD: 1 lần/ngày, 2 lần/ngày, 3 lần/ngày)
        Status NVARCHAR(50) NOT NULL CONSTRAINT DF_Medicine_Status DEFAULT N'Đang dùng' 
            CONSTRAINT CK_Medicine_Status CHECK (Status IN (N'Đang dùng', N'Tạm dừng', N'Đã ngưng')), -- Trạng thái
        Notes NVARCHAR(500) NULL,                                 -- Ghi chú cách dùng / lưu ý y tế
        CreatedAt DATETIME CONSTRAINT DF_Medicine_CreatedAt DEFAULT GETDATE(), -- Thời gian tạo đơn thuốc
        IsActive BIT CONSTRAINT DF_Medicine_IsActive DEFAULT 1   -- Trạng thái hoạt động (1: Hoạt động, 0: Đã xóa mềm)
    );
END
GO

-- Chèn dữ liệu mẫu thử nghiệm (Mock data liên kết chính xác với dữ liệu trong nguoicaotuoi.sql)
IF NOT EXISTS (SELECT 1 FROM Medicine)
BEGIN
    -- Lấy ID của các cụ từ bảng Resident (nguoicaotuoi.sql)
    DECLARE @idAn INT = (SELECT TOP 1 Id FROM Resident WHERE ResidentCode = 'NCT001' OR FullName = N'Nguyễn Văn An');
    DECLARE @idBinh INT = (SELECT TOP 1 Id FROM Resident WHERE ResidentCode = 'NCT002' OR FullName = N'Lê Văn Bình');
    DECLARE @idCuc INT = (SELECT TOP 1 Id FROM Resident WHERE ResidentCode = 'NCT003' OR FullName = N'Phạm Thị Cúc');

    -- Nếu chưa có ID (chưa chạy nguoicaotuoi.sql), gán mặc định 1, 2, 3
    SET @idAn = ISNULL(@idAn, 1);
    SET @idBinh = ISNULL(@idBinh, 2);
    SET @idCuc = ISNULL(@idCuc, 3);

    INSERT INTO Medicine (MedicineName, Dosage, ResidentId, ResidentName, ScheduleTime, Frequency, Status, Notes)
    VALUES 
    (N'Amlodipine 5mg', N'1 viên', @idAn, N'Nguyễn Văn An', '08:00, 20:00', N'2 lần/ngày', N'Đang dùng', N'Uống sau bữa ăn'),
    (N'Metformin 500mg', N'2 viên', @idAn, N'Nguyễn Văn An', '07:00, 12:00, 19:00', N'3 lần/ngày', N'Đang dùng', N'Uống trong bữa ăn'),
    (N'Diclofenac 50mg', N'1 viên', @idBinh, N'Lê Văn Bình', '09:00, 21:00', N'2 lần/ngày', N'Đang dùng', N'Không dùng khi đau dạ dày ...'),
    (N'Calcium + Vitamin D', N'1 viên', @idBinh, N'Lê Văn Bình', '12:00', N'1 lần/ngày', N'Đang dùng', N'Uống sau bữa trưa'),
    (N'Warfarin 2mg', N'1 viên', @idCuc, N'Phạm Thị Cúc', '18:00', N'1 lần/ngày', N'Đang dùng', N'Theo dõi INR định kỳ'),
    (N'Atorvastatin 20mg', N'1 viên', @idCuc, N'Phạm Thị Cúc', '21:00', N'1 lần/ngày', N'Đang dùng', N'Uống buổi tối trước ngủ');
    
    PRINT 'Da chen du lieu mau quan ly thuoc (lien ket nguoicaotuoi.sql) thanh cong!';
END
ELSE
BEGIN
    PRINT 'Bang Medicine da co du lieu. Bo qua chen du lieu mau.';
END
GO
