using Microsoft.AspNetCore.Mvc;
using SilverCare.API.Models;

namespace SilverCare.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        [HttpPost("login-staff")]
        public IActionResult LoginStaff([FromBody] LoginRequest request)
        {
            if (request == null || string.IsNullOrEmpty(request.Username) || string.IsNullOrEmpty(request.Password))
            {
                return BadRequest(new LoginResponse { IsSuccess = false, Message = "Thông tin không hợp lệ." });
            }

            // Đối chiếu dữ liệu mẫu nhân viên từ nhanvien.sql
            if ((request.Username == "a.nguyen@silvercare.vn" || request.Username == "0901234567") && request.Password == "123456")
            {
                return Ok(new LoginResponse { IsSuccess = true, FullName = "Nguyễn Văn A", Role = "Nhân viên" });
            }
            if ((request.Username == "b.tran@silvercare.vn" || request.Username == "0912345678") && request.Password == "123456")
            {
                return Ok(new LoginResponse { IsSuccess = true, FullName = "Trần Thị B", Role = "Nhân viên" });
            }
            if ((request.Username == "c.le@silvercare.vn" || request.Username == "0987654321") && request.Password == "123456")
            {
                return Ok(new LoginResponse { IsSuccess = true, FullName = "Lê Hoàng C", Role = "Nhân viên" });
            }

            return Unauthorized(new LoginResponse { IsSuccess = false, Message = "Email hoặc mật khẩu không hợp lệ, vui lòng nhập lại" });
        }

        [HttpPost("login-family")]
        public IActionResult LoginFamily([FromBody] LoginRequest request)
        {
            if (request == null || string.IsNullOrEmpty(request.Username) || string.IsNullOrEmpty(request.Password))
            {
                return BadRequest(new LoginResponse { IsSuccess = false, Message = "Thông tin không hợp lệ." });
            }

            // Đối chiếu dữ liệu mẫu người nhà từ nguoinha.sql
            if ((request.Username == "example@email.com" || request.Username == "0909090909") && request.Password == "123456")
            {
                return Ok(new LoginResponse { IsSuccess = true, FullName = "Nguyễn Văn Hải", Role = "Người nhà" });
            }

            return Unauthorized(new LoginResponse { IsSuccess = false, Message = "Email hoặc mật khẩu không hợp lệ, vui lòng nhập lại" });
        }
    }
}
