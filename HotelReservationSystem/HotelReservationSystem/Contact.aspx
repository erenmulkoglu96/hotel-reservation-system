<%@ Page Title="İletişim" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="HotelReservationSystem.Admin.Contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .contact-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .contact-header {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 40px;
            border-radius: 15px;
            text-align: center;
            margin-bottom: 40px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .contact-header h1 {
            margin: 0;
            font-size: 36px;
            font-weight: 700;
        }

        .contact-header p {
            margin: 15px 0 0 0;
            font-size: 18px;
            opacity: 0.95;
        }

        .contact-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 40px;
        }

        @media (max-width: 768px) {
            .contact-grid {
                grid-template-columns: 1fr;
            }
        }

        .contact-form-section {
            background: white;
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .contact-form-section h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #555;
            font-size: 14px;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
            font-family: inherit;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #f5576c;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }

        .btn-submit {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 14px 35px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            width: 100%;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(245, 87, 108, 0.4);
        }

        .contact-info-section {
            background: white;
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .contact-info-section h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
        }

        .info-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 25px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
            transition: background 0.3s ease;
        }

        .info-item:hover {
            background: #e9ecef;
        }

        .info-icon {
            font-size: 28px;
            margin-right: 15px;
            min-width: 40px;
        }

        .info-content h3 {
            margin: 0 0 8px 0;
            color: #333;
            font-size: 16px;
            font-weight: 600;
        }

        .info-content p {
            margin: 0;
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }

        .map-section {
            background: white;
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-top: 40px;
        }

        .map-section h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
        }

        .map-container {
            width: 100%;
            height: 400px;
            border-radius: 10px;
            overflow: hidden;
            border: 2px solid #e0e0e0;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="contact-container">
        <div class="contact-header">
            <h1>📧 İletişim</h1>
            <p>Sorularınız ve önerileriniz için bizimle iletişime geçin</p>
        </div>

        <div class="contact-grid">
            <div class="contact-form-section">
                <h2>📝 Mesaj Gönderin</h2>
                
                <asp:Label ID="lblMessage" runat="server" Visible="false"></asp:Label>

                <div class="form-group">
                    <label>Ad Soyad *</label>
                    <asp:TextBox ID="txtName" runat="server" placeholder="Adınız ve soyadınız"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" 
                        ControlToValidate="txtName" 
                        ErrorMessage="Ad Soyad gereklidir" 
                        ForeColor="Red" 
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label>E-posta *</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="ornek@email.com"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                        ControlToValidate="txtEmail" 
                        ErrorMessage="E-posta gereklidir" 
                        ForeColor="Red" 
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                        ControlToValidate="txtEmail" 
                        ErrorMessage="Geçerli bir e-posta adresi girin" 
                        ForeColor="Red" 
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        Display="Dynamic">
                    </asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <label>Telefon</label>
                    <asp:TextBox ID="txtPhone" runat="server" placeholder="0555 123 45 67"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Konu *</label>
                    <asp:TextBox ID="txtSubject" runat="server" placeholder="Mesaj konusu"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSubject" runat="server" 
                        ControlToValidate="txtSubject" 
                        ErrorMessage="Konu gereklidir" 
                        ForeColor="Red" 
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label>Mesajınız *</label>
                    <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" placeholder="Mesajınızı buraya yazın..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvMessage" runat="server" 
                        ControlToValidate="txtMessage" 
                        ErrorMessage="Mesaj gereklidir" 
                        ForeColor="Red" 
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <asp:Button ID="btnSubmit" runat="server" Text="📨 Gönder" CssClass="btn-submit" OnClick="btnSubmit_Click" />
            </div>

            <div class="contact-info-section">
                <h2>📍 İletişim Bilgileri</h2>

                <div class="info-item">
                    <div class="info-icon">🏢</div>
                    <div class="info-content">
                        <h3>Adres</h3>
                        <p>Ankara, Türkiye<br>Çankaya Mahallesi, No: 123</p>
                    </div>
                </div>

                <div class="info-item">
                    <div class="info-icon">📞</div>
                    <div class="info-content">
                        <h3>Telefon</h3>
                        <p>+90 (312) 123 45 67<br>+90 (555) 123 45 67</p>
                    </div>
                </div>

                <div class="info-item">
                    <div class="info-icon">📧</div>
                    <div class="info-content">
                        <h3>E-posta</h3>
                        <p>info@otelrezervasyonsistemi.com<br>destek@otelrezervasyonsistemi.com</p>
                    </div>
                </div>

                <div class="info-item">
                    <div class="info-icon">⏰</div>
                    <div class="info-content">
                        <h3>Çalışma Saatleri</h3>
                        <p>Pazartesi - Cuma: 09:00 - 18:00<br>Cumartesi: 09:00 - 14:00<br>Pazar: Kapalı</p>
                    </div>
                </div>

                <div class="info-item">
                    <div class="info-icon">🌐</div>
                    <div class="info-content">
                        <h3>Sosyal Medya</h3>
                        <p>
                            <a href="#" style="color: #667eea; text-decoration: none; margin-right: 15px;">Facebook</a>
                            <a href="#" style="color: #667eea; text-decoration: none; margin-right: 15px;">Twitter</a>
                            <a href="#" style="color: #667eea; text-decoration: none;">Instagram</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="map-section">
            <h2>🗺️ Konum</h2>
            <div class="map-container">
                <iframe 
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3060.5267822028436!2d32.8540676!3d39.9208484!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14d34f190a9c6b3b%3A0x8c7d0e4cc1c7c0e5!2sAnkara%2C%20T%C3%BCrkiye!5e0!3m2!1str!2str!4v1234567890123!5m2!1str!2str" 
                    width="100%" 
                    height="100%" 
                    style="border:0;" 
                    allowfullscreen="" 
                    loading="lazy" 
                    referrerpolicy="no-referrer-when-downgrade">
                </iframe>
            </div>
        </div>
    </div>
</asp:Content>