<%@ Page Title="Oda Listesi" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RoomList.aspx.cs" Inherits="HotelReservationSystem.Admin.RoomList" %>
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
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .info-box {
            background-color: #e7f3ff;
            border-left: 4px solid #007bff;
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .info-box > div {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            font-size: 13px;
        }
        .toolbar {
            margin-bottom: 20px;
        }
        .status-active {
            color: green;
            font-weight: bold;
            font-size: 12px;
        }
        .status-inactive {
            color: red;
            font-weight: bold;
            font-size: 12px;
        }
        .price-cell {
            text-align: right !important;
            font-weight: bold;
            color: #28a745 !important;
            font-size: 13px;
            padding-right: 12px !important;
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
    
    <h1 style="color: #333; border-bottom: 3px solid #007bff; padding-bottom: 10px; margin-bottom: 30px;">
        🏨 Oda Yönetimi (Telerik RadGrid)
    </h1>
    
    <div class="info-box">
    <div>
        <span>
            <strong>📊 Toplam Oda:</strong> 
            <asp:Label ID="lblTotalRooms" runat="server" Text="0" Font-Bold="true"></asp:Label>
        </span>
        <span>
            <strong>✅ Aktif:</strong> 
            <asp:Label ID="lblActiveRooms" runat="server" Text="0" ForeColor="Green"></asp:Label>
        </span>
        <span>
            <strong>❌ Pasif:</strong> 
            <asp:Label ID="lblInactiveRooms" runat="server" Text="0" ForeColor="Red"></asp:Label>
        </span>
    </div>
</div>

    <div class="toolbar">
        <asp:Button ID="btnAddRoom" runat="server" Text="➕ Yeni Oda Ekle" 
            CssClass="btn btn-primary" OnClick="btnAddRoom_Click" />
        <asp:Button ID="btnRefresh" runat="server" Text="🔄 Yenile" 
            CssClass="btn btn-success" OnClick="btnRefresh_Click" />
    </div>

    <asp:Label ID="lblMessage" runat="server" 
        Font-Bold="True" 
        style="display:block; margin-bottom:15px;"></asp:Label>

    <telerik:RadGrid ID="RadGrid1" runat="server" 
    AutoGenerateColumns="False"
    AllowPaging="True" PageSize="10"
    AllowSorting="True"
    AllowFilteringByColumn="True"
    Skin="MetroTouch"
    Width="100%"
    OnNeedDataSource="RadGrid1_NeedDataSource"
    OnItemCommand="RadGrid1_ItemCommand"
    OnDeleteCommand="RadGrid1_DeleteCommand">
        
        <MasterTableView DataKeyNames="RoomId" CommandItemDisplay="Top">
            <CommandItemSettings ShowRefreshButton="true" ShowExportToExcelButton="true" />
            

           <Columns>
    <telerik:GridBoundColumn DataField="RoomId" HeaderText="ID" 
        UniqueName="RoomId" 
        HeaderStyle-Width="40px"
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="RoomNumber" HeaderText="Oda No" 
        UniqueName="RoomNumber" 
        HeaderStyle-Width="70px" 
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center"
        SortExpression="RoomNumber">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="RoomType.TypeName" HeaderText="Oda Tipi" 
        UniqueName="RoomTypeName" 
        HeaderStyle-Width="100px"
        HeaderStyle-HorizontalAlign="Left"
        ItemStyle-HorizontalAlign="Left"
        SortExpression="RoomType.TypeName">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="Price" HeaderText="Fiyat (₺)" 
        UniqueName="Price" 
        DataFormatString="{0:N0}"
        HeaderStyle-Width="90px" 
        HeaderStyle-HorizontalAlign="Right"
        ItemStyle-CssClass="price-cell"
        SortExpression="Price">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="Capacity" HeaderText="Kapasite" 
        UniqueName="Capacity" 
        HeaderStyle-Width="70px" 
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center"
        SortExpression="Capacity">
    </telerik:GridBoundColumn>

    <telerik:GridBoundColumn DataField="Description" HeaderText="Açıklama" 
        UniqueName="Description" 
        HeaderStyle-Width="250px"
        HeaderStyle-HorizontalAlign="Left"
        ItemStyle-HorizontalAlign="Left">
    </telerik:GridBoundColumn>

    <telerik:GridTemplateColumn HeaderText="Durum" 
        UniqueName="IsActive"
        HeaderStyle-Width="70px"
        HeaderStyle-HorizontalAlign="Center"
        ItemStyle-HorizontalAlign="Center">
        <ItemTemplate>
            <asp:Label ID="lblStatus" runat="server"
                Text='<%# (bool)Eval("IsActive") ? "✅ Aktif" : "❌ Pasif" %>'
                CssClass='<%# (bool)Eval("IsActive") ? "status-active" : "status-inactive" %>'>
            </asp:Label>
        </ItemTemplate>
    </telerik:GridTemplateColumn>

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
        ConfirmText="Bu odayı silmek istediğinize emin misiniz?"
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