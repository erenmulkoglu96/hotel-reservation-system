using System;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace HotelReservationSystem
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SetActivePage();
                SetBreadcrumb();
            }
        }
        private void SetActivePage()
        {
            string currentPage = Request.Url.AbsolutePath.ToLower();

            navHome.Attributes["class"] = "";
            navRooms.Attributes["class"] = "";
            navCustomers.Attributes["class"] = "";
            navReservations.Attributes["class"] = "";
            navReports.Attributes["class"] = "";  

            if (currentPage.Contains("default.aspx") || currentPage.EndsWith("/"))
            {
                navHome.Attributes["class"] = "active";
            }
            else if (currentPage.Contains("roomlist") || currentPage.Contains("roomform"))
            {
                navRooms.Attributes["class"] = "active";
            }
            else if (currentPage.Contains("customerlist") || currentPage.Contains("customerform"))
            {
                navCustomers.Attributes["class"] = "active";
            }
            else if (currentPage.Contains("reservationlist") || currentPage.Contains("reservationform"))
            {
                navReservations.Attributes["class"] = "active";
            }
            else if (currentPage.Contains("reports")) 
            {
                navReports.Attributes["class"] = "active";
            }
        }
        private void SetBreadcrumb()
        {
            string currentPage = Request.Url.AbsolutePath.ToLower();
            string breadcrumb = "";

            if (currentPage.Contains("roomlist"))
            {
                breadcrumb = "<span>Oda Yönetimi</span> › <strong>Oda Listesi</strong>";
            }
            else if (currentPage.Contains("roomform"))
            {
                breadcrumb = "<a href='RoomList.aspx'>Oda Yönetimi</a> › <strong>Oda Ekle/Düzenle</strong>";
            }
            else if (currentPage.Contains("customerlist"))
            {
                breadcrumb = "<span>Müşteri Yönetimi</span> › <strong>Müşteri Listesi</strong>";
            }
            else if (currentPage.Contains("customerform"))
            {
                breadcrumb = "<a href='CustomerList.aspx'>Müşteri Yönetimi</a> › <strong>Müşteri Ekle/Düzenle</strong>";
            }
            else if (currentPage.Contains("reservationlist"))
            {
                breadcrumb = "<span>Rezervasyon Yönetimi</span> › <strong>Rezervasyon Listesi</strong>";
            }
            else if (currentPage.Contains("reservationform"))
            {
                breadcrumb = "<a href='ReservationList.aspx'>Rezervasyon Yönetimi</a> › <strong>Rezervasyon Ekle/Düzenle</strong>";
            }
            else
            {
                breadcrumb = "<strong>Ana Sayfa</strong>";
            }

            litBreadcrumb.Text = breadcrumb;
        }
    }
}