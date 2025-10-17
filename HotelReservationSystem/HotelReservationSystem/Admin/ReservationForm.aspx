<%@ Page Title="Rezervasyon Ekle/Düzenle" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ReservationForm.aspx.cs" Inherits="HotelReservationSystem.Admin.ReservationForm" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #555;
        }
        .required {
            color: red;
        }
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .btn {
            padding: 12px 30px;
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
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        .btn-info {
            background-color: #17a2b8;
            color: white;
        }
        .button-group {
            margin-top: 30px;
            text-align: center;
        }
        .error {
            color: red;
            font-size: 12px;
            margin-top: 5px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }
        .alert {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        .info-box {
            background-color: #d1ecf1;
            border-left: 4px solid #17a2b8;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }
        .info-box strong {
            color: #0c5460;
        }
        .form-row {
            display: flex;
            gap: 20px;
        }
        .form-row .form-group {
            flex: 1;
        }
        .price-display {
            font-size: 24px;
            font-weight: bold;
            color: #28a745;
            text-align: center;
            padding: 15px;
            background-color: #d4edda;
            border-radius: 5px;
            margin: 10px 0;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
    
    <h1 style="color: #333; border-bottom: 3px solid #dc3545; padding-bottom: 10px; margin-bottom: 30px;">
        <asp:Literal ID="litTitle" runat="server" Text="📅 Yeni Rezervasyon Ekle"></asp:Literal>
    </h1>

    <asp:Panel ID="pnlMessage" runat="server" Visible="false">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
    </asp:Panel>

    <div class="form-group">
        <label>Müşteri <span class="required">*</span></label>
        <asp:DropDownList ID="ddlCustomer" runat="server">
        </asp:DropDownList>
        <asp:RequiredFieldValidator ID="rfvCustomer" runat="server" 
            ControlToValidate="ddlCustomer"
            InitialValue="0"
            ErrorMessage="Müşteri seçiniz!" 
            CssClass="error" Display="Dynamic">
        </asp:RequiredFieldValidator>
    </div>

    <div class="form-row">
        <div class="form-group">
            <label>Giriş Tarihi <span class="required">*</span></label>
            <telerik:RadDatePicker ID="rdpCheckIn" runat="server" 
                Width="100%" 
                MinDate="2024-01-01"
                AutoPostBack="true"
                OnSelectedDateChanged="rdpCheckIn_SelectedDateChanged">
                <DateInput DateFormat="dd.MM.yyyy" DisplayDateFormat="dd.MM.yyyy"></DateInput>
            </telerik:RadDatePicker>
            <asp:RequiredFieldValidator ID="rfvCheckIn" runat="server" 
                ControlToValidate="rdpCheckIn"
                ErrorMessage="Giriş tarihi zorunludur!" 
                CssClass="error" Display="Dynamic">
            </asp:RequiredFieldValidator>
        </div>

        <div class="form-group">
            <label>Çıkış Tarihi <span class="required">*</span></label>
            <telerik:RadDatePicker ID="rdpCheckOut" runat="server" 
                Width="100%" 
                MinDate="2024-01-01"
                AutoPostBack="true"
                OnSelectedDateChanged="rdpCheckOut_SelectedDateChanged">
                <DateInput DateFormat="dd.MM.yyyy" DisplayDateFormat="dd.MM.yyyy"></DateInput>
            </telerik:RadDatePicker>
            <asp:RequiredFieldValidator ID="rfvCheckOut" runat="server" 
                ControlToValidate="rdpCheckOut"
                ErrorMessage="Çıkış tarihi zorunludur!" 
                CssClass="error" Display="Dynamic">
            </asp:RequiredFieldValidator>
            <asp:CompareValidator ID="cvCheckOut" runat="server"
                ControlToValidate="rdpCheckOut"
                ControlToCompare="rdpCheckIn"
                Operator="GreaterThan"
                Type="Date"
                ErrorMessage="Çıkış tarihi, giriş tarihinden sonra olmalıdır!"
                CssClass="error" Display="Dynamic">
            </asp:CompareValidator>
        </div>
    </div>

    <div class="form-group" style="text-align: center;">
        <asp:Button ID="btnCheckAvailability" runat="server" 
            Text="🔍 Müsait Odaları Kontrol Et" 
            CssClass="btn btn-info" 
            OnClick="btnCheckAvailability_Click"
            CausesValidation="false" />
    </div>

    <asp:Panel ID="pnlAvailableRooms" runat="server" Visible="false">
        <div class="info-box">
            <strong>ℹ️ Seçilen tarihler arasında müsait odalar aşağıda listelenmektedir.</strong>
        </div>

        <div class="form-group">
            <label>Müsait Oda Seç <span class="required">*</span></label>
            <asp:DropDownList ID="ddlAvailableRooms" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlAvailableRooms_SelectedIndexChanged">
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="rfvRoom" runat="server" 
                ControlToValidate="ddlAvailableRooms"
                InitialValue="0"
                ErrorMessage="Oda seçiniz!" 
                CssClass="error" Display="Dynamic"
                Enabled="false">
            </asp:RequiredFieldValidator>
        </div>

        <asp:Panel ID="pnlPriceInfo" runat="server" Visible="false">
            <div class="info-box">
                <div>
                    <strong>Oda Tipi:</strong> <asp:Label ID="lblRoomType" runat="server"></asp:Label><br />
                    <strong>Günlük Fiyat:</strong> <asp:Label ID="lblDailyPrice" runat="server"></asp:Label> ₺<br />
                    <strong>Konaklama Süresi:</strong> <asp:Label ID="lblTotalDays" runat="server"></asp:Label> gün
                </div>
            </div>
            <div class="price-display">
                Toplam Fiyat: <asp:Label ID="lblTotalPrice" runat="server" Text="0.00"></asp:Label> ₺
            </div>
        </asp:Panel>
    </asp:Panel>

    <div class="form-group">
        <label>Rezervasyon Durumu <span class="required">*</span></label>
        <asp:DropDownList ID="ddlStatus" runat="server">
            <asp:ListItem Value="Pending" Selected="True">⏳ Bekleyen</asp:ListItem>
            <asp:ListItem Value="Confirmed">✅ Onaylı</asp:ListItem>
            <asp:ListItem Value="Cancelled">❌ İptal</asp:ListItem>
            <asp:ListItem Value="Completed">✔️ Tamamlandı</asp:ListItem>
        </asp:DropDownList>
    </div>

    <div class="button-group">
        <asp:Button ID="btnSave" runat="server" Text="💾 Kaydet" 
            CssClass="btn btn-primary" OnClick="btnSave_Click" />
        <asp:Button ID="btnCancel" runat="server" Text="❌ İptal" 
            CssClass="btn btn-secondary" OnClick="btnCancel_Click" 
            CausesValidation="false" />
    </div>
</asp:Content>