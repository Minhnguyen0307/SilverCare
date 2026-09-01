-- ========================================================
-- Tên dự án: SilverCare - Hệ thống quản lý chăm sóc người cao tuổi
-- Mục đích: Khởi tạo bảng Hồ sơ Người cao tuổi (Elderly / Resident)
-- Hệ quản trị cơ sở dữ liệu khuyên dùng: Microsoft SQL Server (MS SQL)
-- ========================================================

USE SilverCareDb;
GO

-- Tạo bảng Người cao tuổi (Resident) nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Resident]') AND type in (N'U'))
BEGIN
    CREATE TABLE Resident (
        Id INT IDENTITY(1,1) PRIMARY KEY,                         -- Khóa chính, ID tự tăng trong DB
        ResidentCode VARCHAR(20) NOT NULL UNIQUE,                 -- Mã hồ sơ người cao tuổi (VD: NCT001, NCT002)
        FullName NVARCHAR(100) NOT NULL,                          -- Họ và tên người cao tuổi
        Age INT NOT NULL CONSTRAINT CK_Resident_Age CHECK (Age >= 50 AND Age <= 125), -- Tuổi người cao tuổi
        Gender NVARCHAR(10) NOT NULL CONSTRAINT CK_Resident_Gender CHECK (Gender IN (N'Nam', N'Nữ')), -- Giới tính
        Room NVARCHAR(50) NOT NULL,                               -- Phòng ở tại trung tâm (VD: Phòng 201, 102, 305)
        BloodGroup VARCHAR(10) NOT NULL CONSTRAINT CK_Resident_Blood CHECK (BloodGroup IN ('A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-')), -- Nhóm máu
        HealthStatus NVARCHAR(50) NOT NULL CONSTRAINT CK_Resident_HealthStatus CHECK (HealthStatus IN (N'Đang ổn định', N'Cần theo dõi', N'Trung bình', N'Yếu')), -- Tình trạng sức khỏe
        
        -- Thông tin người liên hệ (Lấy từ bảng Người nhà - Family)
        ContactPerson NVARCHAR(100) NOT NULL,                     -- Họ tên người nhà liên hệ (trong nguoinha.sql)
        ContactPhone VARCHAR(20) NOT NULL,                        -- Số điện thoại người liên hệ
        Relationship NVARCHAR(50) NOT NULL,                       -- Mối quan hệ (Con trai, Con gái, Chồng, Vợ,...)
        ContactAddress NVARCHAR(255) NULL,                        -- Địa chỉ người liên hệ
        
        AdmissionDate DATE NOT NULL CONSTRAINT DF_Resident_AdmissionDate DEFAULT CAST(GETDATE() AS DATE), -- Ngày tiếp nhận vào trung tâm
        Notes NVARCHAR(500) NULL,                                 -- Ghi chú bệnh nền / chế độ chăm sóc
        CreatedAt DATETIME CONSTRAINT DF_Resident_CreatedAt DEFAULT GETDATE(), -- Thời gian tạo hồ sơ
        IsActive BIT CONSTRAINT DF_Resident_IsActive DEFAULT 1   -- Trạng thái hoạt động (1: Đang ở, 0: Đã xuất viện/Khóa)
    );
END
GO

-- Chèn dữ liệu mẫu thử nghiệm (Mock data tương ứng với nguoinha.sql)
-- Kiểm tra xem bảng đã có dữ liệu chưa để tránh trùng khóa khi chạy lại script
IF NOT EXISTS (SELECT 1 FROM Resident)
BEGIN
    INSERT INTO Resident (ResidentCode, FullName, Age, Gender, Room, BloodGroup, HealthStatus, ContactPerson, ContactPhone, Relationship, ContactAddress, AdmissionDate, Notes)
    VALUES 
    ('NCT001', N'Nguyễn Văn An', 78, N'Nam', N'Phòng 201', 'A+', N'Đang ổn định', N'Nguyễn Văn Hải', '0909090909', N'Con trai', N'123 Nguyễn Trãi, Quận 1, TP. HCM', '2024-05-15', N'Theo dõi huyết áp định kỳ mỗi sáng, chế độ ăn giảm muối.'),
    ('NCT002', N'Lê Văn Bình', 82, N'Nam', N'Phòng 102', 'B+', N'Cần theo dõi', N'Lê Thị Mai', '0918888888', N'Con gái', N'456 Lê Lợi, Quận Gò Vấp, TP. HCM', '2023-11-10', N'Thoái hóa khớp gối, cần hỗ trợ vận động và vật lý trị liệu.'),
    ('NCT003', N'Phạm Thị Cúc', 75, N'Nữ', N'Phòng 305', 'O+', N'Trung bình', N'Trần Minh Hoàng', '0989999999', N'Chồng', N'789 Cách Mạng Tháng 8, Quận 3, TP. HCM', '2024-02-20', N'Tiền sử đường huyết dao động, kiểm tra sức khỏe hàng ngày.');
    
    PRINT 'Da chen du lieu mau ho so nguoi cao tuoi thanh cong!';
END
ELSE
BEGIN
    PRINT 'Bang Resident da co du lieu. Bo qua chen du lieu mau.';
END
GO
