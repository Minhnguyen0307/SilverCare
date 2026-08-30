-- ========================================================
-- Tên dự án: SilverCare - Hệ thống quản lý chăm sóc người cao tuổi
-- Mục đích: Khởi tạo database và bảng Nhân viên (Staff)
-- Hệ quản trị cơ sở dữ liệu khuyên dùng: Microsoft SQL Server (MS SQL)
-- ========================================================

-- 1. Tạo Database SilverCareDb nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SilverCareDb')
BEGIN
    CREATE DATABASE SilverCareDb;
END
GO

USE SilverCareDb;
GO

-- 2. Tạo bảng Nhân viên (Staff) nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Staff]') AND type in (N'U'))
BEGIN
    CREATE TABLE Staff (
        Id INT IDENTITY(1,1) PRIMARY KEY,                         -- Khóa chính, ID tự tăng
        FullName NVARCHAR(100) NOT NULL,                          -- Họ và tên nhân viên
        Email VARCHAR(100) NOT NULL UNIQUE,                       -- Email (Dùng để đăng nhập, không trùng lặp)
        PhoneNumber VARCHAR(20) NOT NULL UNIQUE,                  -- Số điện thoại (Dùng để đăng nhập, không trùng lặp)
        Department NVARCHAR(100) NOT NULL CONSTRAINT CK_Staff_Department CHECK (Department IN (N'Phòng chăm sóc A', N'Phòng chăm sóc B', N'Phòng chăm sóc C')), -- Phòng ban (chỉ nhận A, B, C)
        Password VARCHAR(255) NOT NULL CONSTRAINT DF_Staff_Password DEFAULT '123456', -- Mật khẩu đăng nhập (Mặc định: '123456')
        CreatedAt DATETIME CONSTRAINT DF_Staff_CreatedAt DEFAULT GETDATE(),            -- Thời gian tạo tài khoản
        IsActive BIT CONSTRAINT DF_Staff_IsActive DEFAULT 1                            -- Trạng thái hoạt động (1: Active, 0: Locked)
    );
END
GO

-- 3. Chèn dữ liệu mẫu thử nghiệm (Mock data)
-- Kiểm tra xem đã có dữ liệu chưa trước khi chèn để tránh bị lỗi trùng khóa (Duplicate Key)
IF NOT EXISTS (SELECT 1 FROM Staff)
BEGIN
    INSERT INTO Staff (FullName, Email, PhoneNumber, Department, Password)
    VALUES 
    (N'Nguyễn Văn A', 'a.nguyen@silvercare.vn', '0901234567', N'Phòng chăm sóc A', '123456'),
    (N'Trần Thị B', 'b.tran@silvercare.vn', '0912345678', N'Phòng chăm sóc B', '123456'),
    (N'Lê Hoàng C', 'c.le@silvercare.vn', '0987654321', N'Phòng chăm sóc C', '123456');
    
    PRINT 'Da chen du lieu mau thanh cong!';
END
ELSE
BEGIN
    PRINT 'Bang Staff da co du lieu. Bo qua chen du lieu mau.';
END
GO
