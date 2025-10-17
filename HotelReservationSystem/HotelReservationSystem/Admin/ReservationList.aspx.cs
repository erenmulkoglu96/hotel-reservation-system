using System;
using System.Linq;
using System.Web.UI;
using Telerik.Web.UI;
using HotelReservationSystem.Models;

namespace HotelReservationSystem.Admin
{
    public partial class ReservationList : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["SuccessMessage"] != null)
                {
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Text = Session["SuccessMessage"].ToString();
                    Session.Remove("SuccessMessage");
                }

                UpdateReservationStatistics();
            }
        }
        protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            LoadReservations();
        }
        private void LoadReservations()
        {
            try
            {
                using (var db = new HotelDbContext())
                {
                    var reservations = db.Reservations
                        .Include("Customer")
                        .Include("Room")
                        .Include("Room.RoomType")
                        .OrderByDescending(r => r.CreatedDate)
                        .ToList();

                    RadGrid1.DataSource = reservations;
                }
            }
            catch (Exception ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Hata: " + ex.Message;
            }
        }
        private void UpdateReservationStatistics()
        {
            using (var db = new HotelDbContext())
            {
                lblTotalReservations.Text = db.Reservations.Count().ToString();
                lblPendingReservations.Text = db.Reservations.Count(r => r.Status == "Pending").ToString();
                lblConfirmedReservations.Text = db.Reservations.Count(r => r.Status == "Confirmed").ToString();
                lblCancelledReservations.Text = db.Reservations.Count(r => r.Status == "Cancelled").ToString();
                lblCompletedReservations.Text = db.Reservations.Count(r => r.Status == "Completed").ToString();
            }
        }
        public string GetStatusText(string status)
        {
            switch (status)
            {
                case "Pending":
                    return "⏳ Bekleyen";
                case "Confirmed":
                    return "✅ Onaylı";
                case "Cancelled":
                    return "❌ İptal";
                case "Completed":
                    return "✔️ Tamamlandı";
                default:
                    return status;
            }
        }
        public string GetStatusClass(string status)
        {
            switch (status)
            {
                case "Pending":
                    return "status-pending";
                case "Confirmed":
                    return "status-confirmed";
                case "Cancelled":
                    return "status-cancelled";
                case "Completed":
                    return "status-completed";
                default:
                    return "";
            }
        }
        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                GridDataItem item = (GridDataItem)e.Item;
                int reservationId = Convert.ToInt32(item.GetDataKeyValue("ReservationId"));
                Response.Redirect($"ReservationForm.aspx?id={reservationId}");
            }
        }
        protected void RadGrid1_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            try
            {
                GridDataItem item = (GridDataItem)e.Item;
                int reservationId = Convert.ToInt32(item.GetDataKeyValue("ReservationId"));

                using (var db = new HotelDbContext())
                {
                    var reservation = db.Reservations.Find(reservationId);

                    if (reservation != null)
                    {
                        db.Reservations.Remove(reservation);
                        db.SaveChanges();

                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        lblMessage.Text = $"✅ Rezervasyon başarıyla silindi!";

                        UpdateReservationStatistics();
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Hata: " + ex.Message;
                e.Canceled = true;
            }
        }
        protected void btnAddReservation_Click(object sender, EventArgs e)
        {
            Response.Redirect("ReservationForm.aspx");
        }
        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            RadGrid1.Rebind();
            UpdateReservationStatistics();
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "✅ Liste yenilendi!";
        }
    }
}