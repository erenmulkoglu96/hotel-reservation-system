using System;
using System.Net.Mail;

namespace HotelReservationSystem.Admin
{
    public partial class Contact : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMessage.Visible = false;
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    // Burada normalde e-posta gönderme işlemi yapılır
                    // Şimdilik sadece başarı mesajı gösterelim

                    string name = txtName.Text.Trim();
                    string email = txtEmail.Text.Trim();
                    string phone = txtPhone.Text.Trim();
                    string subject = txtSubject.Text.Trim();
                    string message = txtMessage.Text.Trim();

                    // E-posta gönderme kodu (SMTP ayarlarınızı yapın)
                    // SendEmail(name, email, phone, subject, message);

                    // Başarı mesajı
                    lblMessage.CssClass = "success-message";
                    lblMessage.Text = $"✅ Teşekkürler {name}! Mesajınız başarıyla gönderildi. En kısa sürede size dönüş yapacağız.";
                    lblMessage.Visible = true;

                    // Formu temizle
                    ClearForm();
                }
                catch (Exception ex)
                {
                    lblMessage.CssClass = "error-message";
                    lblMessage.Text = "❌ Bir hata oluştu: " + ex.Message;
                    lblMessage.Visible = true;
                }
            }
        }

        private void ClearForm()
        {
            txtName.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtPhone.Text = string.Empty;
            txtSubject.Text = string.Empty;
            txtMessage.Text = string.Empty;
        }

        // SMTP ile e-posta gönderme metodu (opsiyonel)
        /*
        private void SendEmail(string name, string email, string phone, string subject, string message)
        {
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("noreply@otelrezervasyonsistemi.com");
            mail.To.Add("info@otelrezervasyonsistemi.com");
            mail.Subject = $"İletişim Formu: {subject}";
            mail.Body = $"Ad Soyad: {name}\nE-posta: {email}\nTelefon: {phone}\n\nMesaj:\n{message}";
            
            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.Credentials = new System.Net.NetworkCredential("your-email@gmail.com", "your-password");
            smtp.EnableSsl = true;
            
            smtp.Send(mail);
        }
        */
    }
}