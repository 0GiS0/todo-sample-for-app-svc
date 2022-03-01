using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using DotNetCoreSqlDb.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace DotNetCoreSqlDb.Controllers
{
    public class HomeController : Controller
    {

        private readonly MyDatabaseContext _context;

        public HomeController(MyDatabaseContext context)
        {
            _context = context;
        }
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult ExternalCall()
        {
            var httpClient = new System.Net.Http.HttpClient();
            var response = httpClient.GetAsync("https://dog-api.kinduff.com/api/facts?number=5").Result;

            var result = response.Content.ReadAsStringAsync().Result;

            ViewBag.JsonData = result;

            return View();
        }

        public IActionResult SQLInjection(string query)
        {
            var sql = "SELECT * FROM dbo.Users WHERE UserName = '" + query + "'";

            var todos = _context.Todo.FromSqlRaw(sql).ToList();

            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
