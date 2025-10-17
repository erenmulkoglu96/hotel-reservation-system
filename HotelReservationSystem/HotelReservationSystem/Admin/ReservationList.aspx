<%@ Page Title="Rezervasyon Listesi" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ReservationList.aspx.cs" Inherits="HotelReservationSystem.Admin.ReservationList" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            margin: 5px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background-color: #dc3545;
            color: white;
        }
        .btn-primary:hover {
            background-color: #c82333;
        }
        .btn-success {
            background-color: #17a2b8;
            color: white;
        }
        .info-box {
            background-color: #f8d7da;
            border-left: 4px solid #dc3545;
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .info-box > div {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }
        .toolbar {
            margin-bottom: 20px;
        }
        .status-pending {
            background-color: #ffc107;
            color: white;
            padding: 3px 10px;
            border-radius: 3px;
            font-weight: bold;
            font-size: 11px;
            display: inline-block;
        }
        .status-confirmed {
            background-color: #28a745;
            color: white;
            padding: 3px 10px;
            border-radius: 3px;
            font-weight: bold;
            font-size: 11px;
            display: inline-block;
        }
        .status-cancelled {
            background-color: #dc3545;
            color: white;
            padding: 3px 10px;
            border-radius: 3px;
            font-weight: bold;
            font-size: 11px;
            display: inline-block;
        }
        .status-completed {
            background-color: #6c757d;
            color: white;
            padding: 3px 10px;
            border-radius: 3px;
            font-weight: bold;
            font-size: 11px;
            display: inline-block;
        }
        .price-cell {
            text-align: right !important;
            font-weight: bold;
            color: #28a745 !important;
            font-size: 13px;
            padding-right: 12px !important;
        }
        .stat-item {
            font-size: 13px;
        }
        
        .RadGrid {
            font-size: 13px !important;
        }
        
        .RadGrid .rgHeader,
        .RadGrid th {
            font-size: 13px !important;
            font-weight: bold !important;
            padding: 8px 8px !important;
            vertical-align: middle !important;
        }
        
        .RadGrid td {
            padding: 6px 8px !important;
            vertical-align: middle !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
    
    <h1 style="color: #333; border-bottom: 3px solid #dc3545; padding-bottom: 10px; margin-bottom: 30px;">
        📅 Rezervasyon Yönetimi
    </h1>
    
    <div class="info-box">
        <div style="display: flex;">
            <div class="stat-item">
                <strong>📊 Toplam Rezervasyon:</strong> 
                <asp:Label ID="lblTotalReservations" runat="server" Text="0" Font-Bold="true" Font-Size="16px"></asp:Label>
            </div>
            <div class="stat-item">
                <strong>⏳ Bekleyen:</strong> 
                <asp:Label ID="lblPendingReservations" runat="server" Text="0" ForeColor="#856404"></asp:Label>
            </div>
            <div class="stat-item">
                <strong>✅ Onaylı:</strong> 
                <asp:Label ID="lblConfirmedReservations" runat="server" Text="0" ForeColor="Green"></asp:Label>
            </div>
            <div class="stat-item">
                <strong>❌ İptal:</strong> 
                <asp:Label ID="lblCancelledReservations" runat="server" Text="0" ForeColor="Red"></asp:Label>
            </div>
            <div class="stat-item">
                <strong>✔️ Tamamlanan:</strong> 
                <asp:Label ID="lblCompletedReservations" runat="server" Text="0" ForeColor="Gray"></asp:Label>
            </div>
        </div>
    </div>

    <div class="toolbar">
        <asp:Button ID="btnAddReservation" runat="server" Text="➕ Yeni Rezervasyon Ekle" 
            CssClass="btn btn-primary" OnClick="btnAddReservation_Click" />
        <asp:Button ID="btnRefresh" runat="server" Text="🔄 Yenile" 
            CssClass="btn btn-success" OnClick="btnRefresh_Click" />
    </div>

    <asp:Label ID="lblMessage" runat="server" 
        Font-Bold="True" 
        style="display:block; margin-bottom:15px;"></asp:Label>

    <telerik:RadGrid ID="RadGrid1" runat="server" 
    AutoGenerateColumns="False"
    AllowPaging="True" PageSize="15"
    AllowSorting="True"
    AllowFilteringByColumn="True"
    Skin="MetroTouch"
    Width="100%"
    OnNeedDataSource="RadGrid1_NeedDataSource"
    OnItemCommand="RadGrid1_ItemCommand"
    OnDeleteCommand="RadGrid1_DeleteCommand">
        
        <MasterTableView DataKeyNames="ReservationId" CommandItemDisplay="Top">
            <CommandItemSettings ShowRefreshButton="true" ShowExportToExcelButton="true" />
            
           <Columns>
    <telerik:GridBoundColumn DataField="ReservationId" HeaderText="ID" 
        UniqueName="ReservationId" 
        FilterControlWidth="35px"
        HeaderStyle-Width="50px"
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="Customer.FullName" HeaderText="Müşteri" 
        UniqueName="CustomerName" 
        FilterControlWidth="90px"
        HeaderStyle-Width="140px" 
        HeaderStyle-HorizontalAlign="Left"
        ItemStyle-HorizontalAlign="Left"
        SortExpression="Customer.FirstName">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="Room.RoomNumber" HeaderText="Oda" 
        UniqueName="RoomNumber" 
        FilterControlWidth="40px"
        HeaderStyle-Width="60px" 
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center"
        SortExpression="Room.RoomNumber">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="Room.RoomType.TypeName" HeaderText="Tip" 
        UniqueName="RoomType" 
        FilterControlWidth="55px"
        HeaderStyle-Width="85px"
        HeaderStyle-HorizontalAlign="Left"
        ItemStyle-HorizontalAlign="Left">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="CheckInDate" HeaderText="Giriş" 
        UniqueName="CheckInDate" 
        DataFormatString="{0:dd.MM.yy}"
        FilterControlWidth="65px"
        HeaderStyle-Width="85px" 
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center"
        SortExpression="CheckInDate">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="CheckOutDate" HeaderText="Çıkış" 
        UniqueName="CheckOutDate" 
        DataFormatString="{0:dd.MM.yy}"
        FilterControlWidth="65px"
        HeaderStyle-Width="85px" 
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center"
        SortExpression="CheckOutDate">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="TotalDays" HeaderText="Gün" 
        UniqueName="TotalDays"
        FilterControlWidth="40px"
        HeaderStyle-Width="60px"
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="TotalPrice" HeaderText="Fiyat" 
        UniqueName="TotalPrice" 
        DataFormatString="{0:N0}"
        FilterControlWidth="60px"
        HeaderStyle-Width="90px" 
        HeaderStyle-HorizontalAlign="Right"
        ItemStyle-CssClass="price-cell">
    </telerik:GridBoundColumn>

    <telerik:GridTemplateColumn HeaderText="Durum" 
        UniqueName="Status"
        FilterControlWidth="70px"
        HeaderStyle-Width="100px"
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center">
        <ItemTemplate>
            <asp:Label ID="lblStatus" runat="server"
                Text='<%# GetStatusText(Eval("Status").ToString()) %>'
                CssClass='<%# GetStatusClass(Eval("Status").ToString()) %>'>
            </asp:Label>
        </ItemTemplate>
    </telerik:GridTemplateColumn>

    <telerik:GridBoundColumn DataField="CreatedDate" HeaderText="Kayıt" 
        UniqueName="CreatedDate" 
        DataFormatString="{0:dd.MM.yy}"
        FilterControlWidth="65px"
        HeaderStyle-Width="85px" 
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center"
        SortExpression="CreatedDate">
    </telerik:GridBoundColumn>

    <telerik:GridButtonColumn CommandName="Edit" 
        Text="✏️" 
        UniqueName="EditColumn" 
        ButtonType="LinkButton"
        HeaderStyle-Width="45px"
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center">
    </telerik:GridButtonColumn>

    <telerik:GridButtonColumn CommandName="Delete" 
        Text="🗑️" 
        UniqueName="DeleteColumn" 
        ButtonType="LinkButton"
        ConfirmText="Bu rezervasyonu silmek istediğinize emin misiniz?"
        ConfirmDialogType="RadWindow"
        HeaderStyle-Width="45px"
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center">
    </telerik:GridButtonColumn>
</Columns>
        </MasterTableView>

        <PagerStyle Mode="NextPrevAndNumeric" />
        <FilterMenu EnableImageSprites="False"></FilterMenu>
    </telerik:RadGrid>
</asp:Content>