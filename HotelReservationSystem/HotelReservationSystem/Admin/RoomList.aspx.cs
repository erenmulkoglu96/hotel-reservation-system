using System;
using System.Linq;
using System.Web.UI;
using Telerik.Web.UI;
using HotelReservationSystem.Models;

namespace HotelReservationSystem.Admin
{
    public partial class RoomList : BasePage
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

                UpdateRoomStatistics();
            }
        }
        protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            LoadRooms();
        }
        private void LoadRooms()
        {
            try
            {
                using (var db = new HotelDbContext())
                {
                    var rooms = db.Rooms
                        .Include("RoomType")
                        .OrderBy(r => r.RoomNumber)
                        .ToList();

                    RadGrid1.DataSource = rooms;
                }
            }
            catch (Exception ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Hata: " + ex.Message;
            }
        }
        private void UpdateRoomStatistics()
        {
            using (var db = new HotelDbContext())
            {
                int totalRooms = db.Rooms.Count();
                int activeRooms = db.Rooms.Count(r => r.IsActive);
                int inactiveRooms = totalRooms - activeRooms;

                lblTotalRooms.Text = totalRooms.ToString();
                lblActiveRooms.Text = activeRooms.ToString();
                lblInactiveRooms.Text = inactiveRooms.ToString();
            }
        }
        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                GridDataItem item = (GridDataItem)e.Item;
                int roomId = Convert.ToInt32(item.GetDataKeyValue("RoomId"));

                Response.Redirect($"RoomForm.aspx?id={roomId}");
            }
        }
        protected void RadGrid1_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            try
            {
                GridDataItem item = (GridDataItem)e.Item;
                int roomId = Convert.ToInt32(item.GetDataKeyValue("RoomId"));

                using (var db = new HotelDbContext())
                {
                    var room = db.Rooms.Find(roomId);

                    if (room != null)
                    {
                        bool hasReservations = db.Reservations.Any(r => r.RoomId == roomId);

                        if (hasReservations)
                        {
                            lblMessage.ForeColor = System.Drawing.Color.Red;
                            lblMessage.Text = "❌ Bu oda silinemez! Üzerinde rezervasyonlar var.";
                            e.Canceled = true;
                        }
                        else
                        {
                            db.Rooms.Remove(room);
                            db.SaveChanges();

                            lblMessage.ForeColor = System.Drawing.Color.Green;
                            lblMessage.Text = $"✅ Oda {room.RoomNumber} başarıyla silindi!";

                            UpdateRoomStatistics();
                        }
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
        protected void btnAddRoom_Click(object sender, EventArgs e)
        {
            Response.Redirect("RoomForm.aspx");
        }
        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            RadGrid1.Rebind();
            UpdateRoomStatistics();
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "✅ Liste yenilendi!";
        }
    }
}