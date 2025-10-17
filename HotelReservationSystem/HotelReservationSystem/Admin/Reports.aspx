<%@ Page Title="Raporlar" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="HotelReservationSystem.Admin.Reports" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .report-header {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .report-header h1 {
            margin: 0;
            font-size: 28px;
        }
        .filter-section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .filter-section h3 {
            margin-top: 0;
            color: #333;
            border-bottom: 2px solid #f5576c;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .filter-row {
            display: flex;
            gap: 20px;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        .filter-group {
            flex: 1;
            min-width: 200px;
        }
        .filter-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
            color: #555;
        }
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background-color: #f5576c;
            color: white;
        }
        .btn-primary:hover {
            background-color: #e0495a;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .summary-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid;
        }
        .summary-card.revenue { border-left-color: #28a745; }
        .summary-card.reservations { border-left-color: #007bff; }
        .summary-card.occupancy { border-left-color: #ffc107; }
        .summary-card.average { border-left-color: #17a2b8; }

        .summary-card .icon {
            font-size: 30px;
            margin-bottom: 10px;
        }
        .summary-card .title {
            color: #6c757d;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .summary-card .value {
            font-size: 32px;
            font-weight: bold;
            color: #333;
        }
        .summary-card .subtitle {
            color: #6c757d;
            font-size: 12px;
            margin-top: 5px;
        }
        .report-table {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .report-table h3 {
            margin-top: 0;
            color: #333;
            border-bottom: 2px solid #f5576c;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .chart-container {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            min-height: 300px;
        }
        .chart-container h3 {
            margin-top: 0;
            color: #333;
            border-bottom: 2px solid #f5576c;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
    
    <div class="report-header">
        <h1>📊 Raporlar ve Analizler</h1>
        <p>Detaylı istatistikler ve performans analizleri</p>
    </div>
    <div class="filter-section">
        <h3>🔍 Rapor Filtresi</h3>
        <div class="filter-row">
            <div class="filter-group">
                <label>Başlangıç Tarihi</label>
                <telerik:RadDatePicker ID="rdpStartDate" runat="server" Width="100%">
                    <DateInput DateFormat="dd.MM.yyyy" DisplayDateFormat="dd.MM.yyyy"></DateInput>
                </telerik:RadDatePicker>
            </div>
            <div class="filter-group">
                <label>Bitiş Tarihi</label>
                <telerik:RadDatePicker ID="rdpEndDate" runat="server" Width="100%">
                    <DateInput DateFormat="dd.MM.yyyy" DisplayDateFormat="dd.MM.yyyy"></DateInput>
                </telerik:RadDatePicker>
            </div>
            <div class="filter-group">
                <asp:Button ID="btnGenerateReport" runat="server" 
                    Text="📈 Rapor Oluştur" 
                    CssClass="btn btn-primary" 
                    OnClick="btnGenerateReport_Click" 
                    CausesValidation="false" />
            </div>
        </div>
    </div>
    <asp:Panel ID="pnlSummary" runat="server" Visible="false">
        <div class="summary-grid">
            <div class="summary-card revenue">
                <div class="icon">💰</div>
                <div class="title">Toplam Gelir</div>
                <div class="value">
                    <asp:Label ID="lblTotalRevenue" runat="server" Text="0"></asp:Label> ₺
                </div>
                <div class="subtitle">
                    <asp:Label ID="lblRevenueSubtitle" runat="server"></asp:Label>
                </div>
            </div>

            <div class="summary-card reservations">
                <div class="icon">📅</div>
                <div class="title">Toplam Rezervasyon</div>
                <div class="value">
                    <asp:Label ID="lblTotalReservations" runat="server" Text="0"></asp:Label>
                </div>
                <div class="subtitle">
                    <asp:Label ID="lblReservationSubtitle" runat="server"></asp:Label>
                </div>
            </div>

            <div class="summary-card occupancy">
                <div class="icon">📊</div>
                <div class="title">Doluluk Oranı</div>
                <div class="value">
                    <asp:Label ID="lblOccupancyRate" runat="server" Text="0"></asp:Label>%
                </div>
                <div class="subtitle">
                    <asp:Label ID="lblOccupancySubtitle" runat="server"></asp:Label>
                </div>
            </div>

            <div class="summary-card average">
                <div class="icon">💵</div>
                <div class="title">Ortalama Rezervasyon Tutarı</div>
                <div class="value">
                    <asp:Label ID="lblAverageRevenue" runat="server" Text="0"></asp:Label> ₺
                </div>
                <div class="subtitle">Rezervasyon başına</div>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlTopRooms" runat="server" Visible="false">
        <div class="report-table">
            <h3>🏆 En Çok Rezerve Edilen Odalar</h3>
            <telerik:RadGrid ID="RadGridTopRooms" runat="server" 
                AutoGenerateColumns="False"
                Skin="MetroTouch"
                Width="100%">
                
                <MasterTableView>
                    <Columns>
    <telerik:GridBoundColumn DataField="RoomNumber" HeaderText="Oda No" 
        HeaderStyle-Width="80px"
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="RoomTypeName" HeaderText="Oda Tipi" 
        HeaderStyle-Width="120px"
        HeaderStyle-HorizontalAlign="Left"
        ItemStyle-HorizontalAlign="Left">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="ReservationCount" HeaderText="Rezervasyon Sayısı" 
        HeaderStyle-Width="150px" 
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="TotalRevenue" HeaderText="Toplam Gelir (₺)" 
        DataFormatString="{0:N0}" 
        HeaderStyle-Width="140px" 
        HeaderStyle-HorizontalAlign="Right"
        ItemStyle-HorizontalAlign="Right" 
        ItemStyle-Font-Bold="true"
        ItemStyle-ForeColor="#28a745">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="AveragePrice" HeaderText="Ortalama Fiyat (₺)" 
        DataFormatString="{0:N0}" 
        HeaderStyle-Width="140px" 
        HeaderStyle-HorizontalAlign="Right"
        ItemStyle-HorizontalAlign="Right">
    </telerik:GridBoundColumn>
</Columns>
                </MasterTableView>
            </telerik:RadGrid>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlDetailedReport" runat="server" Visible="false">
        <div class="report-table">
            <h3>📋 Detaylı Rezervasyon Raporu</h3>
            <div style="margin-bottom: 15px;">
                <asp:Button ID="btnExportExcel" runat="server" 
                    Text="📥 Excel'e Aktar" 
                    CssClass="btn btn-success" 
                    OnClick="btnExportExcel_Click" 
                    CausesValidation="false" />
            </div>
            
            <telerik:RadGrid ID="RadGridDetailed" runat="server" 
                AutoGenerateColumns="False"
                AllowPaging="True" PageSize="20"
                AllowSorting="True"
                Skin="MetroTouch"
                Width="100%"
                OnNeedDataSource="RadGridDetailed_NeedDataSource">
                
                <MasterTableView CommandItemDisplay="Top">
                    <CommandItemSettings ShowExportToExcelButton="true" />
                    
                    <Columns>
                        <telerik:GridBoundColumn DataField="ReservationId" HeaderText="ID" 
                            HeaderStyle-Width="60px">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="CustomerName" HeaderText="Müşteri" 
                            HeaderStyle-Width="180px">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="RoomNumber" HeaderText="Oda" 
                            HeaderStyle-Width="80px">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="CheckInDate" HeaderText="Giriş" 
                            DataFormatString="{0:dd.MM.yyyy}" HeaderStyle-Width="100px">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="CheckOutDate" HeaderText="Çıkış" 
                            DataFormatString="{0:dd.MM.yyyy}" HeaderStyle-Width="100px">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="TotalDays" HeaderText="Gün" 
                            HeaderStyle-Width="60px" ItemStyle-HorizontalAlign="Center">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="TotalPrice" HeaderText="Tutar (₺)" 
                            DataFormatString="{0:N2}" HeaderStyle-Width="120px" 
                            ItemStyle-HorizontalAlign="Right" ItemStyle-Font-Bold="true" 
                            ItemStyle-ForeColor="#28a745">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="Status" HeaderText="Durum" 
                            HeaderStyle-Width="100px">
                        </telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>

                <ExportSettings ExportOnlyData="true" IgnorePaging="true" OpenInNewWindow="true">
                    <Excel Format="Xlsx" />
                </ExportSettings>
            </telerik:RadGrid>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlNoData" runat="server" Visible="false">
        <div class="no-data">
            <h3>📭 Veri Bulunamadı</h3>
            <p>Seçilen tarih aralığında rezervasyon bulunamadı.</p>
        </div>
    </asp:Panel>
</asp:Content>