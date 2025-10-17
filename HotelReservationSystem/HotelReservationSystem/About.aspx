<%@ Page Title="Hakkımızda" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="HotelReservationSystem.Admin.About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .about-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            max-width: 1000px;
            margin: 0 auto;
        }

        .about-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 40px;
            text-align: center;
        }

        .about-header h1 {
            margin: 0;
            font-size: 36px;
            font-weight: 700;
        }

        .about-header p {
            margin: 10px 0 0 0;
            font-size: 18px;
            opacity: 0.95;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin: 40px 0;
        }

        .feature-card {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .feature-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .feature-card h3 {
            color: #333;
            margin: 10px 0;
            font-size: 20px;
        }

        .feature-card p {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }

        .tech-section {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 10px;
            margin: 40px 0;
        }

        .tech-section h2 {
            color: #333;
            margin-bottom: 20px;
            text-align: center;
            font-size: 28px;
        }

        .tech-stack {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
        }

        .tech-badge {
            background: white;
            padding: 12px 24px;
            border-radius: 25px;
            font-weight: 600;
            color: #667eea;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            font-size: 14px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 40px 0;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
        }

        .stat-number {
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .stat-label {
            font-size: 16px;
            opacity: 0.95;
        }

        .about-text {
            color: #555;
            line-height: 1.8;
            font-size: 16px;
            margin: 20px 0;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="about-container">
        <div class="about-header">
            <h1>🏨 Otel Rezervasyon Sistemi</h1>
            <p>Modern, Güvenilir ve Kullanıcı Dostu Otel Yönetim Çözümü</p>
        </div>

        <div class="about-text">
            <p>
                Otel Rezervasyon Sistemi, otel işletmelerinin rezervasyon süreçlerini dijitalleştirmek ve 
                yönetimini kolaylaştırmak amacıyla geliştirilmiş kapsamlı bir web uygulamasıdır. 
                Sistem, modern teknolojiler kullanılarak oluşturulmuş olup, kullanıcı dostu arayüzü 
                ve güçlü özellikleriyle otel yönetimini kolaylaştırır.
            </p>
        </div>

        <div class="feature-grid">
            <div class="feature-card">
                <div class="feature-icon">🏨</div>
                <h3>Oda Yönetimi</h3>
                <p>Tüm odalarınızı tek bir platformdan yönetin. Oda tipleri, fiyatlandırma ve müsaitlik durumunu kolayca takip edin.</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">📅</div>
                <h3>Rezervasyon Takibi</h3>
                <p>Rezervasyonları anlık olarak takip edin. Onay, iptal ve tamamlama süreçlerini kolayca yönetin.</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">👥</div>
                <h3>Müşteri Yönetimi</h3>
                <p>Müşteri bilgilerini güvenli bir şekilde saklayın ve müşteri geçmişini kolayca görüntüleyin.</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">📊</div>
                <h3>Detaylı Raporlar</h3>
                <p>Gelir, doluluk oranı ve rezervasyon istatistiklerini görselleştirin. İş kararlarınızı veriye dayandırın.</p>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">
                    <asp:Label ID="lblTotalRooms" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Toplam Oda</div>
            </div>

            <div class="stat-card">
                <div class="stat-number">
                    <asp:Label ID="lblTotalReservations" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Toplam Rezervasyon</div>
            </div>

            <div class="stat-card">
                <div class="stat-number">
                    <asp:Label ID="lblTotalCustomers" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Kayıtlı Müşteri</div>
            </div>
        </div>

        <div class="tech-section">
            <h2>💻 Kullanılan Teknolojiler</h2>
            <div class="tech-stack">
                <span class="tech-badge">ASP.NET Web Forms</span>
                <span class="tech-badge">C# .NET Framework</span>
                <span class="tech-badge">Entity Framework 6</span>
                <span class="tech-badge">SQL Server</span>
                <span class="tech-badge">Telerik UI</span>
                <span class="tech-badge">HTML5 & CSS3</span>
                <span class="tech-badge">JavaScript</span>
            </div>
        </div>

        <div class="about-text" style="text-align: center; margin-top: 40px;">
            <h2 style="color: #667eea; margin-bottom: 15px;">🎯 Misyonumuz</h2>
            <p>
                Otel işletmelerinin dijital dönüşümüne katkıda bulunmak ve rezervasyon süreçlerini 
                en verimli şekilde yönetmelerini sağlamak. Müşteri memnuniyetini artırmak ve 
                operasyonel verimliliği maksimize etmek için sürekli gelişim ve yenilik odaklı çalışıyoruz.
            </p>
        </div>
    </div>
</asp:Content>