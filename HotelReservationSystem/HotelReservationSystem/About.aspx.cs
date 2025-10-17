using System;
using System.Linq;
using HotelReservationSystem.Models;

namespace HotelReservationSystem.Admin
{
    public partial class About : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStatistics();
            }
        }

        private void LoadStatistics()
        {
            try
            {
                using (var db = new HotelDbContext())
                {
                    lblTotalRooms.Text = db.Rooms.Count().ToString();
                    lblTotalReservations.Text = db.Reservations.Count().ToString();
                    lblTotalCustomers.Text = db.Customers.Count().ToString();
                }
            }
            catch
            {
                lblTotalRooms.Text = "0";
                lblTotalReservations.Text = "0";
                lblTotalCustomers.Text = "0";
            }
        }
    }
}