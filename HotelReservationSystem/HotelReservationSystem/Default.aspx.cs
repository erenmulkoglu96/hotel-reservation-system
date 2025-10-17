using System;
using System.Linq;
using System.Web.UI;
using HotelReservationSystem.Models;

namespace HotelReservationSystem
{
    public partial class _Default : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardData();
            }
        }
        private void LoadDashboardData()
        {
            using (var db = new HotelDbContext())
            {
                LoadRoomStatistics(db);
                LoadCustomerStatistics(db);
                LoadReservationStatistics(db);
                LoadRevenueStatistics(db);
                LoadTodayActivities(db);
            }
        }
        private void LoadRoomStatistics(HotelDbContext db)
        {
            int totalRooms = db.Rooms.Count();
            int activeRooms = db.Rooms.Count(r => r.IsActive);
            int inactiveRooms = totalRooms - activeRooms;

            lblTotalRooms.Text = totalRooms.ToString();
            lblActiveRooms.Text = activeRooms.ToString();
            lblInactiveRooms.Text = inactiveRooms.ToString();
        }
        private void LoadCustomerStatistics(HotelDbContext db)
        {
            int totalCustomers = db.Customers.Count();
            lblTotalCustomers.Text = totalCustomers.ToString();
        }
        private void LoadReservationStatistics(HotelDbContext db)
        {
            int totalReservations = db.Reservations.Count();
            int activeReservations = db.Reservations.Count(r =>
                r.Status == "Confirmed" || r.Status == "Pending");
            int pendingReservations = db.Reservations.Count(r => r.Status == "Pending");

            lblTotalReservations.Text = totalReservations.ToString();
            lblActiveReservations.Text = activeReservations.ToString();
            lblPendingReservations.Text = pendingReservations.ToString();
        }
        private void LoadRevenueStatistics(HotelDbContext db)
        {
            DateTime startOfMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            DateTime endOfMonth = startOfMonth.AddMonths(1);

            var monthlyReservations = db.Reservations
                .Where(r => r.CreatedDate >= startOfMonth &&
                           r.CreatedDate < endOfMonth &&
                           r.Status != "Cancelled")
                .ToList();

            decimal monthlyRevenue = monthlyReservations.Sum(r => r.TotalPrice);
            int reservationCount = monthlyReservations.Count;

            lblMonthlyRevenue.Text = monthlyRevenue.ToString("N0");
            lblMonthlyReservationCount.Text = reservationCount.ToString();
        }
        private void LoadTodayActivities(HotelDbContext db)
        {
            DateTime today = DateTime.Today;

            var todayCheckIns = db.Reservations
                .Include("Customer")
                .Include("Room")
                .Include("Room.RoomType")
                .Where(r => r.CheckInDate == today &&
                           (r.Status == "Confirmed" || r.Status == "Pending"))
                .OrderBy(r => r.Customer.FirstName)
                .ToList();

            if (todayCheckIns.Any())
            {
                rptCheckIns.DataSource = todayCheckIns;
                rptCheckIns.DataBind();
                lblNoCheckIns.Visible = false;
            }
            else
            {
                lblNoCheckIns.Visible = true;
            }

            var todayCheckOuts = db.Reservations
                .Include("Customer")
                .Include("Room")
                .Include("Room.RoomType")
                .Where(r => r.CheckOutDate == today &&
                           (r.Status == "Confirmed" || r.Status == "Pending"))
                .OrderBy(r => r.Customer.FirstName)
                .ToList();

            if (todayCheckOuts.Any())
            {
                rptCheckOuts.DataSource = todayCheckOuts;
                rptCheckOuts.DataBind();
                lblNoCheckOuts.Visible = false;
            }
            else
            {
                lblNoCheckOuts.Visible = true;
            }
        }
    }
}