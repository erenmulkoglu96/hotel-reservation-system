using System;
using System.Web;
using System.Web.UI;

namespace HotelReservationSystem
{
    public class BasePage : Page
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
        }
        protected int CurrentUserId
        {
            get { return Session["UserId"] != null ? (int)Session["UserId"] : 0; }
        }
       protected string CurrentUserName
        {
            get { return Session["Username"] != null ? Session["Username"].ToString() : ""; }
        }
        protected string CurrentUserFullName
        {
            get { return Session["FullName"] != null ? Session["FullName"].ToString() : ""; }
        }
        protected string CurrentUserRole
        {
            get { return Session["Role"] != null ? Session["Role"].ToString() : ""; }
        }
    }
}