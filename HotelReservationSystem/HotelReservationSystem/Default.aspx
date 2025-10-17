<%@ Page Title="Ana Sayfa" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="HotelReservationSystem._Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .dashboard-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .dashboard-header h1 {
            margin: 0;
            font-size: 32px;
        }
        .dashboard-header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        .stat-card.blue { border-left-color: #007bff; }
        .stat-card.green { border-left-color: #28a745; }
        .stat-card.red { border-left-color: #dc3545; }
        .stat-card.orange { border-left-color: #fd7e14; }

        .stat-icon {
            font-size: 40px;
            margin-bottom: 10px;
        }
        .stat-title {
            color: #6c757d;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 10px;
        }
        .stat-value {
            font-size: 36px;
            font-weight: bold;
            color: #333;
        }
        .stat-description {
            color: #6c757d;
            font-size: 12px;
            margin-top: 8px;
        }
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        .quick-action-btn {
            display: block;
            padding: 20px;
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            text-align: center;
            text-decoration: none;
            color: #333;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .quick-action-btn:hover {
            border-color: #007bff;
            background: #f8f9fa;
            transform: translateY(-3px);
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        .quick-action-btn .icon {
            font-size: 30px;
            margin-bottom: 10px;
            display: block;
        }
        .today-section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .today-section h2 {
            margin-top: 0;
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        .today-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .today-item {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .today-item:last-child {
            border-bottom: none;
        }
        .today-item .info {
            flex: 1;
        }
        .today-item .customer-name {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }
        .today-item .room-info {
            color: #6c757d;
            font-size: 14px;
        }
        .today-item .badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge.check-in {
            background-color: #d4edda;
            color: #155724;
        }
        .badge.check-out {
            background-color: #fff3cd;
            color: #856404;
        }
        .revenue-card {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            margin-bottom: 30px;
        }
        .revenue-card h2 {
            margin: 0 0 20px 0;
            font-size: 18px;
            opacity: 0.9;
        }
        .revenue-amount {
            font-size: 48px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .revenue-description {
            opacity: 0.9;
            font-size: 14px;
        }
        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .quick-actions {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dashboard-header">
        <h1>🏨 Hoş Geldiniz!</h1>
        <p>Otel Rezervasyon Yönetim Sistemi - Genel Bakış ve İstatistikler</p>
    </div>

    <div class="stats-grid">
        <div class="stat-card blue">
            <div class="stat-icon">🛏️</div>
            <div class="stat-title">Toplam Oda</div>
            <div class="stat-value">
                <asp:Label ID="lblTotalRooms" runat="server" Text="0"></asp:Label>
            </div>
            <div class="stat-description">
                <asp:Label ID="lblActiveRooms" runat="server" Text="0"></asp:Label> aktif,
                <asp:Label ID="lblInactiveRooms" runat="server" Text="0"></asp:Label> pasif
            </div>
        </div>

        <div class="stat-card green">
            <div class="stat-icon">👥</div>
            <div class="stat-title">Toplam Müşteri</div>
            <div class="stat-value">
                <asp:Label ID="lblTotalCustomers" runat="server" Text="0"></asp:Label>
            </div>
            <div class="stat-description">Kayıtlı müşteri sayısı</div>
        </div>

        <div class="stat-card red">
            <div class="stat-icon">📅</div>
            <div class="stat-title">Toplam Rezervasyon</div>
            <div class="stat-value">
                <asp:Label ID="lblTotalReservations" runat="server" Text="0"></asp:Label>
            </div>
            <div class="stat-description">
                <asp:Label ID="lblActiveReservations" runat="server" Text="0"></asp:Label> aktif rezervasyon
            </div>
        </div>

        <div class="stat-card orange">
            <div class="stat-icon">⏳</div>
            <div class="stat-title">Bekleyen Rezervasyon</div>
            <div class="stat-value">
                <asp:Label ID="lblPendingReservations" runat="server" Text="0"></asp:Label>
            </div>
            <div class="stat-description">Onay bekleyen</div>
        </div>
    </div>

    <div class="revenue-card">
        <h2>💰 Bu Ayki Toplam Gelir</h2>
        <div class="revenue-amount">
            <asp:Label ID="lblMonthlyRevenue" runat="server" Text="0"></asp:Label> ₺
        </div>
        <div class="revenue-description">
            <asp:Label ID="lblMonthlyReservationCount" runat="server" Text="0"></asp:Label> 
            rezervasyondan elde edildi
        </div>
    </div>

    <h2 style="margin-bottom: 15px; color: #333;">⚡ Hızlı İşlemler</h2>
    <div class="quick-actions">
        <a href="Admin/RoomList.aspx" class="quick-action-btn">
            <span class="icon">🛏️</span>
            Oda Yönetimi
        </a>
        <a href="Admin/CustomerList.aspx" class="quick-action-btn">
            <span class="icon">👥</span>
            Müşteri Yönetimi
        </a>
        <a href="Admin/ReservationList.aspx" class="quick-action-btn">
            <span class="icon">📅</span>
            Rezervasyon Yönetimi
        </a>
        <a href="Admin/ReservationForm.aspx" class="quick-action-btn">
            <span class="icon">➕</span>
            Yeni Rezervasyon
        </a>
    </div>

    <div class="today-section">
        <h2>📆 Bugünkü Hareketler</h2>
        
        <h3 style="color: #28a745; margin-top: 20px;">✅ Giriş Yapacaklar (Check-In)</h3>
        <asp:Panel ID="pnlCheckIns" runat="server">
            <ul class="today-list">
                <asp:Repeater ID="rptCheckIns" runat="server">
                    <ItemTemplate>
                        <li class="today-item">
                            <div class="info">
                                <div class="customer-name">
                                    <%# Eval("Customer.FullName") %>
                                </div>
                                <div class="room-info">
                                    Oda <%# Eval("Room.RoomNumber") %> - 
                                    <%# Eval("Room.RoomType.TypeName") %> - 
                                    <%# Eval("TotalDays") %> gün
                                </div>
                            </div>
                            <span class="badge check-in">Giriş</span>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
            <asp:Label ID="lblNoCheckIns" runat="server" 
                Text="Bugün giriş yapacak müşteri yok." 
                Visible="false" 
                ForeColor="Gray" 
                Style="display: block; padding: 15px; text-align: center;">
            </asp:Label>
        </asp:Panel>

        <h3 style="color: #fd7e14; margin-top: 30px;">📤 Çıkış Yapacaklar (Check-Out)</h3>
        <asp:Panel ID="pnlCheckOuts" runat="server">
            <ul class="today-list">
                <asp:Repeater ID="rptCheckOuts" runat="server">
                    <ItemTemplate>
                        <li class="today-item">
                            <div class="info">
                                <div class="customer-name">
                                    <%# Eval("Customer.FullName") %>
                                </div>
                                <div class="room-info">
                                    Oda <%# Eval("Room.RoomNumber") %> - 
                                    <%# Eval("Room.RoomType.TypeName") %> - 
                                    Toplam: <%# Eval("TotalPrice", "{0:N2}") %> ₺
                                </div>
                            </div>
                            <span class="badge check-out">Çıkış</span>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
            <asp:Label ID="lblNoCheckOuts" runat="server" 
                Text="Bugün çıkış yapacak müşteri yok." 
                Visible="false" 
                ForeColor="Gray" 
                Style="display: block; padding: 15px; text-align: center;">
            </asp:Label>
        </asp:Panel>
    </div>
</asp:Content>