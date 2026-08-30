using Microsoft.AspNetCore.Mvc;
using System.Net.Http;
using System.Text.Json;
using System.Text;
using System.Threading.Tasks;

namespace SilverCare.Controllers
{
    public class HomeController : Controller
    {
        private readonly HttpClient _httpClient;

        // Constructor injecting HttpClient
        public HomeController(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public IActionResult Index()
        {
            return View();
        }


        [HttpGet]
        public IActionResult Staff()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Staff(string username, string password)
        {
            var loginRequest = new { Username = username, Password = password };
            var jsonContent = new StringContent(JsonSerializer.Serialize(loginRequest), Encoding.UTF8, "application/json");

            try
            {
                var response = await _httpClient.PostAsync("http://localhost:5100/api/auth/login-staff", jsonContent);
                if (response.IsSuccessStatusCode)
                {
                    var responseString = await response.Content.ReadAsStringAsync();
                    var loginResponse = JsonSerializer.Deserialize<LoginResponseModel>(responseString, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                    
                    TempData["FullName"] = loginResponse?.FullName ?? "Nguyễn Văn A";
                    TempData["Role"] = "Nhân viên";

                    return RedirectToAction("Dashboard");
                }
            }
            catch (HttpRequestException)
            {
                ViewBag.Error = "Không thể kết nối đến máy chủ Backend. Vui lòng thử lại sau.";
                return View();
            }

            ViewBag.Error = "Email hoặc mật khẩu không hợp lệ, vui lòng nhập lại";
            return View();
        }

        [HttpGet]
        public IActionResult Family()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Family(string username, string password)
        {
            var loginRequest = new { Username = username, Password = password };
            var jsonContent = new StringContent(JsonSerializer.Serialize(loginRequest), Encoding.UTF8, "application/json");

            try
            {
                var response = await _httpClient.PostAsync("http://localhost:5100/api/auth/login-family", jsonContent);
                if (response.IsSuccessStatusCode)
                {
                    var responseString = await response.Content.ReadAsStringAsync();
                    var loginResponse = JsonSerializer.Deserialize<LoginResponseModel>(responseString, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                    
                    TempData["FullName"] = loginResponse?.FullName ?? "Nguyễn Văn Hải";
                    TempData["Role"] = "Người nhà";

                    return RedirectToAction("Dashboard");
                }
            }
            catch (HttpRequestException)
            {
                ViewBag.Error = "Không thể kết nối đến máy chủ Backend. Vui lòng thử lại sau.";
                return View();
            }

            ViewBag.Error = "Email hoặc mật khẩu không hợp lệ, vui lòng nhập lại";
            return View();
        }

        [HttpGet]
        public IActionResult Dashboard()
        {
            return View();
        }

        [HttpGet]
        public IActionResult Health()
        {
            return View();
        }

        public IActionResult LoginSuccess(string role)
        {
            ViewBag.Role = role;
            return View();
        }

        private class LoginResponseModel
        {
            public bool IsSuccess { get; set; }
            public string Message { get; set; } = string.Empty;
            public string FullName { get; set; } = string.Empty;
            public string Role { get; set; } = string.Empty;
        }
    }
}
