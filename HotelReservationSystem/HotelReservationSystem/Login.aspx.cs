using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using HotelReservationSystem.Models;

namespace HotelReservationSystem
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] != null)
                {
                    Response.Redirect("~/Default.aspx");
                }
            }
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            try
            {
                using (var db = new HotelDbContext())
                {
                    var user = db.Users
                        .FirstOrDefault(u => u.Username == username &&
                                           u.Password == password &&
                                           u.IsActive);

                    if (user != null)
                    {
                        Session["UserId"] = user.UserId;
                        Session["Username"] = user.Username;
                        Session["FullName"] = user.FullName;
                        Session["Role"] = user.Role;

                        Response.Redirect("~/Default.aspx");
                    }
                    else
                    {
                        ShowError("❌ Kullanıcı adı veya şifre hatalı!");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Hata: " + ex.Message);
            }
        }
        private void ShowError(string message)
        {
            lblError.Text = message;
            pnlError.Visible = true;
        }
    }
}