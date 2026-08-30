-- ========================================================
-- Tên dự án: SilverCare - Hệ thống quản lý chăm sóc người cao tuổi
-- Mục đích: Khởi tạo bảng Người nhà (Family)
-- Hệ quản trị cơ sở dữ liệu khuyên dùng: Microsoft SQL Server (MS SQL)
-- ========================================================

USE SilverCareDb;
GO

-- Tạo bảng Người nhà (Family) nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Family]') AND type in (N'U'))
BEGIN
    CREATE TABLE Family (
        Id INT IDENTITY(1,1) PRIMARY KEY,                         -- Khóa chính, ID tự tăng
        FullName NVARCHAR(100) NOT NULL,                          -- Họ và tên người nhà
        Email VARCHAR(100) NOT NULL UNIQUE,                       -- Email (Dùng để đăng nhập, không trùng lặp)
        PhoneNumber VARCHAR(20) NOT NULL UNIQUE,                  -- Số điện thoại (Dùng để đăng nhập, không trùng lặp)
        Address NVARCHAR(255) NOT NULL,                           -- Địa chỉ liên hệ
        Relationship NVARCHAR(50) NOT NULL CONSTRAINT CK_Family_Relationship CHECK (Relationship IN (N'Vợ', N'Chồng', N'Con trai', N'Con gái', N'Anh trai', N'Chị gái', N'Em trai', N'Em gái', N'Cháu', N'Khác')), -- Mối quan hệ với người thân
        ResidentName NVARCHAR(100) NOT NULL,                      -- Họ tên người thân đang sinh sống tại trung tâm
        AdmissionDate DATE NOT NULL,                              -- Ngày người thân nhập trung tâm
        Room NVARCHAR(50) NOT NULL,                               -- Phòng của người thân tại trung tâm
        Password VARCHAR(255) NOT NULL CONSTRAINT DF_Family_Password DEFAULT '123456', -- Mật khẩu đăng nhập (Mặc định: '123456')
        CreatedAt DATETIME CONSTRAINT DF_Family_CreatedAt DEFAULT GETDATE(),            -- Thời gian tạo tài khoản
        IsActive BIT CONSTRAINT DF_Family_IsActive DEFAULT 1                            -- Trạng thái hoạt động (1: Active, 0: Locked)
    );
END
GO

-- Chèn dữ liệu mẫu thử nghiệm (Mock data)
-- Kiểm tra xem bảng đã có dữ liệu chưa để tránh trùng khóa (Duplicate Key) khi chạy lại
IF NOT EXISTS (SELECT 1 FROM Family)
BEGIN
    INSERT INTO Family (FullName, Email, PhoneNumber, Address, Relationship, ResidentName, AdmissionDate, Room, Password)
    VALUES 
    (N'Nguyễn Văn Hải', 'example@email.com', '0909090909', N'123 Nguyễn Trãi, Quận 1, TP. HCM', N'Con trai', N'Nguyễn Văn An', '2024-05-15', N'Phòng 201', '123456'),
    (N'Lê Thị Mai', 'mai.le@email.com', '0918888888', N'456 Lê Lợi, Quận Gò Vấp, TP. HCM', N'Con gái', N'Lê Văn Bình', '2023-11-10', N'Phòng 102', '123456'),
    (N'Trần Minh Hoàng', 'hoang.tran@email.com', '0989999999', N'789 Cách Mạng Tháng 8, Quận 3, TP. HCM', N'Chồng', N'Phạm Thị Cúc', '2024-02-20', N'Phòng 305', '123456');
    
    PRINT 'Da chen du lieu mau nguoi nha thanh cong!';
END
ELSE
BEGIN
    PRINT 'Bang Family da co du lieu. Bo qua chen du lieu mau.';
END
GO
