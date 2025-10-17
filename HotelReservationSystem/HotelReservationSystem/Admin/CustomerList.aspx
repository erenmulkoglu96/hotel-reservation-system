<%@ Page Title="Müşteri Listesi" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerList.aspx.cs" Inherits="HotelReservationSystem.Admin.CustomerList" %>
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
            background-color: #28a745;
            color: white;
        }
        .btn-primary:hover {
            background-color: #218838;
        }
        .btn-success {
            background-color: #17a2b8;
            color: white;
        }
        .info-box {
            background-color: #d4edda;
            border-left: 4px solid #28a745;
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .info-box > div {
            font-size: 13px;
        }
        .toolbar {
            margin-bottom: 20px;
        }
        .email-cell {
            color: #007bff !important;
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
    
    <h1 style="color: #333; border-bottom: 3px solid #28a745; padding-bottom: 10px; margin-bottom: 30px;">
        👥 Müşteri Yönetimi
    </h1>
    
    <div class="info-box">
        <div>
            <strong>📊 Toplam Müşteri Sayısı:</strong> 
            <asp:Label ID="lblTotalCustomers" runat="server" Text="0" Font-Bold="true" Font-Size="16px"></asp:Label>
        </div>
    </div>

    <div class="toolbar">
        <asp:Button ID="btnAddCustomer" runat="server" Text="➕ Yeni Müşteri Ekle" 
            CssClass="btn btn-primary" OnClick="btnAddCustomer_Click" />
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
        
        <MasterTableView DataKeyNames="CustomerId" CommandItemDisplay="Top">
            <CommandItemSettings ShowRefreshButton="true" ShowExportToExcelButton="true" />
            
            <Columns>
    <telerik:GridBoundColumn DataField="CustomerId" HeaderText="ID" 
        UniqueName="CustomerId" 
        HeaderStyle-Width="40px"
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="FirstName" HeaderText="Ad" 
        UniqueName="FirstName" 
        HeaderStyle-Width="120px"
        HeaderStyle-HorizontalAlign="Left"
        ItemStyle-HorizontalAlign="Left"
        SortExpression="FirstName">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="LastName" HeaderText="Soyad" 
        UniqueName="LastName" 
        HeaderStyle-Width="120px"
        HeaderStyle-HorizontalAlign="Left"
        ItemStyle-HorizontalAlign="Left"
        SortExpression="LastName">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="Email" HeaderText="E-posta" 
        UniqueName="Email" 
        HeaderStyle-Width="180px"
        HeaderStyle-HorizontalAlign="Left"
        ItemStyle-CssClass="email-cell">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="Phone" HeaderText="Telefon" 
        UniqueName="Phone" 
        HeaderStyle-Width="110px"
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="IdentityNumber" HeaderText="TC Kimlik" 
        UniqueName="IdentityNumber" 
        HeaderStyle-Width="100px"
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="CreatedDate" HeaderText="Kayıt" 
        UniqueName="CreatedDate" 
        DataFormatString="{0:dd.MM.yy HH:mm}"
        HeaderStyle-Width="110px"
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
        ConfirmText="Bu müşteriyi silmek istediğinize emin misiniz?"
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