using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using HotelReservationSystem.Models;

namespace HotelReservationSystem.Admin
{
    public partial class ReservationForm : BasePage
    {
        private int? ReservationId
        {
            get
            {
                if (Request.QueryString["id"] != null)
                {
                    int id;
                    if (int.TryParse(Request.QueryString["id"], out id))
                        return id;
                }
                return null;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCustomers();

                rdpCheckIn.MinDate = DateTime.Today;
                rdpCheckOut.MinDate = DateTime.Today;

                if (ReservationId.HasValue)
                {
                    litTitle.Text = "✏️ Rezervasyon Düzenle";
                    LoadReservationData(ReservationId.Value);
                }
                else
                {
                    litTitle.Text = "📅 Yeni Rezervasyon Ekle";
                }
            }
        }
        private void LoadCustomers()
        {
            using (var db = new HotelDbContext())
            {
                var customers = db.Customers
                    .OrderBy(c => c.FirstName)
                    .ToList();

                ddlCustomer.DataSource = customers;
                ddlCustomer.DataTextField = "FullName";
                ddlCustomer.DataValueField = "CustomerId";
                ddlCustomer.DataBind();

                ddlCustomer.Items.Insert(0, new ListItem("-- Müşteri Seçiniz --", "0"));
            }
        }
        private void LoadReservationData(int reservationId)
        {
            using (var db = new HotelDbContext())
            {
                var reservation = db.Reservations
                    .Include("Customer")
                    .Include("Room")
                    .Include("Room.RoomType")
                    .FirstOrDefault(r => r.ReservationId == reservationId);

                if (reservation != null)
                {
                    ddlCustomer.SelectedValue = reservation.CustomerId.ToString();
                    rdpCheckIn.SelectedDate = reservation.CheckInDate;
                    rdpCheckOut.SelectedDate = reservation.CheckOutDate;
                    ddlStatus.SelectedValue = reservation.Status;

                    CheckAvailability();
                    ddlAvailableRooms.SelectedValue = reservation.RoomId.ToString();
                    CalculatePrice();
                }
                else
                {
                    Response.Redirect("ReservationList.aspx");
                }
            }
        }
        protected void rdpCheckIn_SelectedDateChanged(object sender, EventArgs e)
        {
            if (rdpCheckIn.SelectedDate.HasValue)
            {
                rdpCheckOut.MinDate = rdpCheckIn.SelectedDate.Value.AddDays(1);

                if (rdpCheckOut.SelectedDate.HasValue &&
                    rdpCheckOut.SelectedDate.Value <= rdpCheckIn.SelectedDate.Value)
                {
                    rdpCheckOut.SelectedDate = null;
                }
            }

            pnlAvailableRooms.Visible = false;
            pnlPriceInfo.Visible = false;
        }
        protected void rdpCheckOut_SelectedDateChanged(object sender, EventArgs e)
        {
            pnlAvailableRooms.Visible = false;
            pnlPriceInfo.Visible = false;
        }
        protected void btnCheckAvailability_Click(object sender, EventArgs e)
        {
            CheckAvailability();
        }
        private void CheckAvailability()
        {
            if (!rdpCheckIn.SelectedDate.HasValue || !rdpCheckOut.SelectedDate.HasValue)
            {
                ShowMessage("Lütfen giriş ve çıkış tarihlerini seçiniz!", false);
                return;
            }

            DateTime checkIn = rdpCheckIn.SelectedDate.Value;
            DateTime checkOut = rdpCheckOut.SelectedDate.Value;

            if (checkOut <= checkIn)
            {
                ShowMessage("Çıkış tarihi, giriş tarihinden sonra olmalıdır!", false);
                return;
            }

            using (var db = new HotelDbContext())
            {
                var allRooms = db.Rooms
                    .Include("RoomType")
                    .Where(r => r.IsActive)
                    .ToList();

                var reservedRoomIds = db.Reservations
                    .Where(r => r.Status != "Cancelled" && 
                               (
                                   (checkIn >= r.CheckInDate && checkIn < r.CheckOutDate) ||
                                   (checkOut > r.CheckInDate && checkOut <= r.CheckOutDate) ||
                                   (checkIn <= r.CheckInDate && checkOut >= r.CheckOutDate)
                               ))
                    .Select(r => r.RoomId)
                    .ToList();

                if (ReservationId.HasValue)
                {
                    var currentReservation = db.Reservations.Find(ReservationId.Value);
                    if (currentReservation != null)
                    {
                        reservedRoomIds.Remove(currentReservation.RoomId);
                    }
                }

                var availableRooms = allRooms
                    .Where(r => !reservedRoomIds.Contains(r.RoomId))
                    .OrderBy(r => r.RoomNumber)
                    .ToList();

                if (availableRooms.Any())
                {
                    ddlAvailableRooms.DataSource = availableRooms;
                    ddlAvailableRooms.DataTextField = "RoomNumber";
                    ddlAvailableRooms.DataValueField = "RoomId";
                    ddlAvailableRooms.DataBind();

                    for (int i = 0; i < ddlAvailableRooms.Items.Count; i++)
                    {
                        var room = availableRooms[i];
                        ddlAvailableRooms.Items[i].Text =
                            $"Oda {room.RoomNumber} - {room.RoomType.TypeName} - {room.Price:N2} ₺/gün";
                    }

                    ddlAvailableRooms.Items.Insert(0, new ListItem("-- Oda Seçiniz --", "0"));

                    pnlAvailableRooms.Visible = true;
                    rfvRoom.Enabled = true;

                    ShowMessage($"✅ {availableRooms.Count} adet müsait oda bulundu!", true);
                }
                else
                {
                    pnlAvailableRooms.Visible = false;
                    ShowMessage("❌ Seçilen tarihler arasında müsait oda bulunmamaktadır!", false);
                }
            }
        }
        protected void ddlAvailableRooms_SelectedIndexChanged(object sender, EventArgs e)
        {
            CalculatePrice();
        }
        private void CalculatePrice()
        {
            if (ddlAvailableRooms.SelectedValue == "0" ||
                !rdpCheckIn.SelectedDate.HasValue ||
                !rdpCheckOut.SelectedDate.HasValue)
            {
                pnlPriceInfo.Visible = false;
                return;
            }

            int roomId = int.Parse(ddlAvailableRooms.SelectedValue);
            DateTime checkIn = rdpCheckIn.SelectedDate.Value;
            DateTime checkOut = rdpCheckOut.SelectedDate.Value;

            using (var db = new HotelDbContext())
            {
                var room = db.Rooms.Include("RoomType").FirstOrDefault(r => r.RoomId == roomId);

                if (room != null)
                {
                    int totalDays = (checkOut - checkIn).Days;
                    decimal totalPrice = room.Price * totalDays;

                    lblRoomType.Text = room.RoomType.TypeName;
                    lblDailyPrice.Text = room.Price.ToString("N2");
                    lblTotalDays.Text = totalDays.ToString();
                    lblTotalPrice.Text = totalPrice.ToString("N2");

                    pnlPriceInfo.Visible = true;
                }
            }
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            if (!pnlAvailableRooms.Visible)
            {
                ShowMessage("Lütfen önce 'Müsait Odaları Kontrol Et' butonuna tıklayınız!", false);
                return;
            }

            if (ddlAvailableRooms.SelectedValue == "0")
            {
                ShowMessage("Lütfen bir oda seçiniz!", false);
                return;
            }

            try
            {
                using (var db = new HotelDbContext())
                {
                    Reservation reservation;

                    if (ReservationId.HasValue)
                    {
                        reservation = db.Reservations.Find(ReservationId.Value);
                        if (reservation == null)
                        {
                            ShowMessage("Rezervasyon bulunamadı!", false);
                            return;
                        }
                    }
                    else
                    {
                        reservation = new Reservation();
                        reservation.CreatedDate = DateTime.Now;
                        db.Reservations.Add(reservation);
                    }

                    reservation.CustomerId = int.Parse(ddlCustomer.SelectedValue);
                    reservation.RoomId = int.Parse(ddlAvailableRooms.SelectedValue);
                    reservation.CheckInDate = rdpCheckIn.SelectedDate.Value;
                    reservation.CheckOutDate = rdpCheckOut.SelectedDate.Value;
                    reservation.TotalPrice = decimal.Parse(lblTotalPrice.Text);
                    reservation.Status = ddlStatus.SelectedValue;

                    db.SaveChanges();

                    Session["SuccessMessage"] = ReservationId.HasValue
                        ? "✅ Rezervasyon başarıyla güncellendi!"
                        : "✅ Rezervasyon başarıyla oluşturuldu!";

                    Response.Redirect("ReservationList.aspx");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Hata: " + ex.Message, false);
            }
        }
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("ReservationList.aspx");
        }
        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            pnlMessage.Visible = true;
            pnlMessage.CssClass = isSuccess ? "success" : "alert";
        }
    }
}