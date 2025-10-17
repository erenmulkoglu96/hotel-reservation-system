using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using HotelReservationSystem.Models;

namespace HotelReservationSystem.Admin
{
    public partial class RoomForm : BasePage
    {
        private int? RoomId
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
                LoadRoomTypes();

                if (RoomId.HasValue)
                {
                    litTitle.Text = "✏️ Oda Düzenle";
                    LoadRoomData(RoomId.Value);
                }
                else
                {
                    litTitle.Text = "🏨 Yeni Oda Ekle";
                }
            }
        }
        private void LoadRoomTypes()
        {
            using (var db = new HotelDbContext())
            {
                var roomTypes = db.RoomTypes
                    .OrderBy(rt => rt.TypeName)
                    .ToList();

                ddlRoomType.DataSource = roomTypes;
                ddlRoomType.DataTextField = "TypeName";
                ddlRoomType.DataValueField = "RoomTypeId";
                ddlRoomType.DataBind();

                ddlRoomType.Items.Insert(0, new ListItem("-- Seçiniz --", "0"));
            }
        }
        private void LoadRoomData(int roomId)
        {
            using (var db = new HotelDbContext())
            {
                var room = db.Rooms.Find(roomId);

                if (room != null)
                {
                    txtRoomNumber.Text = room.RoomNumber;
                    ddlRoomType.SelectedValue = room.RoomTypeId.ToString();
                    txtPrice.Text = room.Price.ToString("F2");
                    txtCapacity.Text = room.Capacity.ToString();
                    txtDescription.Text = room.Description;
                    chkIsActive.Checked = room.IsActive;
                }
                else
                {
                    Response.Redirect("RoomList.aspx");
                }
            }
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                using (var db = new HotelDbContext())
                {
                    Room room;

                    if (RoomId.HasValue)
                    {
                        room = db.Rooms.Find(RoomId.Value);
                        if (room == null)
                        {
                            ShowMessage("Oda bulunamadı!", false);
                            return;
                        }
                    }
                    else
                    {
                        room = new Room();

                        bool roomNumberExists = db.Rooms.Any(r => r.RoomNumber == txtRoomNumber.Text.Trim());
                        if (roomNumberExists)
                        {
                            ShowMessage("Bu oda numarası zaten kayıtlı!", false);
                            return;
                        }

                        db.Rooms.Add(room);
                    }

                    room.RoomNumber = txtRoomNumber.Text.Trim();
                    room.RoomTypeId = int.Parse(ddlRoomType.SelectedValue);
                    room.Price = decimal.Parse(txtPrice.Text);
                    room.Capacity = int.Parse(txtCapacity.Text);
                    room.Description = txtDescription.Text.Trim();
                    room.IsActive = chkIsActive.Checked;

                    db.SaveChanges();

                    Session["SuccessMessage"] = RoomId.HasValue
                        ? $"✅ Oda {room.RoomNumber} başarıyla güncellendi!"
                        : $"✅ Oda {room.RoomNumber} başarıyla eklendi!";

                    Response.Redirect("RoomList.aspx");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Hata: " + ex.Message, false);
            }
        }
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("RoomList.aspx");
        }
        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            pnlMessage.Visible = true;
            pnlMessage.CssClass = isSuccess ? "success" : "alert";
        }
    }
}