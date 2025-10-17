using System;
using System.Linq;
using System.Web.UI;
using HotelReservationSystem.Models;

namespace HotelReservationSystem.Admin
{
    public partial class CustomerForm : BasePage
    {
        private int? CustomerId
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
                if (CustomerId.HasValue)
                {
                    litTitle.Text = "✏️ Müşteri Düzenle";
                    LoadCustomerData(CustomerId.Value);
                }
                else
                {
                    litTitle.Text = "👥 Yeni Müşteri Ekle";
                }
            }
        }
        private void LoadCustomerData(int customerId)
        {
            using (var db = new HotelDbContext())
            {
                var customer = db.Customers.Find(customerId);

                if (customer != null)
                {
                    txtFirstName.Text = customer.FirstName;
                    txtLastName.Text = customer.LastName;
                    txtEmail.Text = customer.Email;
                    txtPhone.Text = customer.Phone;
                    txtIdentityNumber.Text = customer.IdentityNumber;
                }
                else
                {
                    Response.Redirect("CustomerList.aspx");
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
                    Customer customer;

                    if (CustomerId.HasValue)
                    {
                        customer = db.Customers.Find(CustomerId.Value);
                        if (customer == null)
                        {
                            ShowMessage("Müşteri bulunamadı!", false);
                            return;
                        }
                    }
                    else
                    {
                        customer = new Customer();

                        bool emailExists = db.Customers.Any(c => c.Email == txtEmail.Text.Trim());
                        if (emailExists)
                        {
                            ShowMessage("Bu e-posta adresi zaten kayıtlı!", false);
                            return;
                        }

                        customer.CreatedDate = DateTime.Now;
                        db.Customers.Add(customer);
                    }

                    customer.FirstName = txtFirstName.Text.Trim();
                    customer.LastName = txtLastName.Text.Trim();
                    customer.Email = txtEmail.Text.Trim();
                    customer.Phone = txtPhone.Text.Trim();
                    customer.IdentityNumber = txtIdentityNumber.Text.Trim();

                    db.SaveChanges();

                    Session["SuccessMessage"] = CustomerId.HasValue
                        ? $"✅ Müşteri {customer.FullName} başarıyla güncellendi!"
                        : $"✅ Müşteri {customer.FullName} başarıyla eklendi!";

                    Response.Redirect("CustomerList.aspx");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Hata: " + ex.Message, false);
            }
        }
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("CustomerList.aspx");
        }
        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            pnlMessage.Visible = true;
            pnlMessage.CssClass = isSuccess ? "success" : "alert";
        }
    }
}