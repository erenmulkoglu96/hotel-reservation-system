using System;
using System.Linq;
using System.Web.UI;
using Telerik.Web.UI;
using HotelReservationSystem.Models;

namespace HotelReservationSystem.Admin
{
    public partial class CustomerList : BasePage
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

                UpdateCustomerStatistics();
            }
        }
        protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            LoadCustomers();
        }
        private void LoadCustomers()
        {
            try
            {
                using (var db = new HotelDbContext())
                {
                    var customers = db.Customers
                        .OrderByDescending(c => c.CreatedDate)
                        .ToList();

                    RadGrid1.DataSource = customers;
                }
            }
            catch (Exception ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Hata: " + ex.Message;
            }
        }
        private void UpdateCustomerStatistics()
        {
            using (var db = new HotelDbContext())
            {
                lblTotalCustomers.Text = db.Customers.Count().ToString();
            }
        }
        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                GridDataItem item = (GridDataItem)e.Item;
                int customerId = Convert.ToInt32(item.GetDataKeyValue("CustomerId"));
                Response.Redirect($"CustomerForm.aspx?id={customerId}");
            }
        }
        protected void RadGrid1_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            try
            {
                GridDataItem item = (GridDataItem)e.Item;
                int customerId = Convert.ToInt32(item.GetDataKeyValue("CustomerId"));

                using (var db = new HotelDbContext())
                {
                    var customer = db.Customers.Find(customerId);

                    if (customer != null)
                    {
                        bool hasReservations = db.Reservations.Any(r => r.CustomerId == customerId);

                        if (hasReservations)
                        {
                            lblMessage.ForeColor = System.Drawing.Color.Red;
                            lblMessage.Text = "❌ Bu müşteri silinemez! Üzerinde rezervasyonlar var.";
                            e.Canceled = true;
                        }
                        else
                        {
                            db.Customers.Remove(customer);
                            db.SaveChanges();

                            lblMessage.ForeColor = System.Drawing.Color.Green;
                            lblMessage.Text = $"✅ Müşteri {customer.FullName} başarıyla silindi!";

                            UpdateCustomerStatistics();
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
        protected void btnAddCustomer_Click(object sender, EventArgs e)
        {
            Response.Redirect("CustomerForm.aspx");
        }
        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            RadGrid1.Rebind();
            UpdateCustomerStatistics();
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "✅ Liste yenilendi!";
        }
    }
}