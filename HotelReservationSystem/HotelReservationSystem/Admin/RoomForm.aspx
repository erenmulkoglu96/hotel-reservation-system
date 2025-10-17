<%@ Page Title="Oda Ekle/Düzenle" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RoomForm.aspx.cs" Inherits="HotelReservationSystem.Admin.RoomForm" %>

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
        input[type="text"],
        input[type="number"],
        select,
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        .checkbox-group {
            margin-top: 10px;
        }
        .checkbox-group input {
            width: auto;
            margin-right: 10px;
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
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 style="color: #333; border-bottom: 3px solid #007bff; padding-bottom: 10px; margin-bottom: 30px;">
        <asp:Literal ID="litTitle" runat="server" Text="🏨 Yeni Oda Ekle"></asp:Literal>
    </h1>

    <asp:Panel ID="pnlMessage" runat="server" Visible="false">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
    </asp:Panel>

    <div class="form-group">
        <label>Oda Numarası <span class="required">*</span></label>
        <asp:TextBox ID="txtRoomNumber" runat="server" MaxLength="10" placeholder="Örn: 101"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvRoomNumber" runat="server" 
            ControlToValidate="txtRoomNumber"
            ErrorMessage="Oda numarası zorunludur!" 
            CssClass="error" Display="Dynamic">
        </asp:RequiredFieldValidator>
    </div>

    <div class="form-group">
        <label>Oda Tipi <span class="required">*</span></label>
        <asp:DropDownList ID="ddlRoomType" runat="server">
        </asp:DropDownList>
        <asp:RequiredFieldValidator ID="rfvRoomType" runat="server" 
            ControlToValidate="ddlRoomType"
            InitialValue="0"
            ErrorMessage="Oda tipi seçiniz!" 
            CssClass="error" Display="Dynamic">
        </asp:RequiredFieldValidator>
    </div>

    <div class="form-group">
        <label>Günlük Fiyat (₺) <span class="required">*</span></label>
        <asp:TextBox ID="txtPrice" runat="server" TextMode="Number" 
            step="0.01" min="0" placeholder="Örn: 500.00"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvPrice" runat="server" 
            ControlToValidate="txtPrice"
            ErrorMessage="Fiyat zorunludur!" 
            CssClass="error" Display="Dynamic">
        </asp:RequiredFieldValidator>
        <asp:RangeValidator ID="rvPrice" runat="server" 
            ControlToValidate="txtPrice"
            MinimumValue="0" MaximumValue="999999"
            Type="Double"
            ErrorMessage="Geçerli bir fiyat giriniz!" 
            CssClass="error" Display="Dynamic">
        </asp:RangeValidator>
    </div>

    <div class="form-group">
        <label>Kapasite (Kişi) <span class="required">*</span></label>
        <asp:TextBox ID="txtCapacity" runat="server" TextMode="Number" 
            min="1" max="10" placeholder="Örn: 2"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvCapacity" runat="server" 
            ControlToValidate="txtCapacity"
            ErrorMessage="Kapasite zorunludur!" 
            CssClass="error" Display="Dynamic">
        </asp:RequiredFieldValidator>
        <asp:RangeValidator ID="rvCapacity" runat="server" 
            ControlToValidate="txtCapacity"
            MinimumValue="1" MaximumValue="10"
            Type="Integer"
            ErrorMessage="Kapasite 1-10 arasında olmalıdır!" 
            CssClass="error" Display="Dynamic">
        </asp:RangeValidator>
    </div>

    <div class="form-group">
        <label>Açıklama</label>
        <asp:TextBox ID="txtDescription" runat="server" 
            TextMode="MultiLine" MaxLength="500"
            placeholder="Oda hakkında detaylı bilgi..."></asp:TextBox>
    </div>

    <div class="form-group checkbox-group">
        <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
        <label style="display: inline; font-weight: normal;">Oda Aktif</label>
    </div>

    <div class="button-group">
        <asp:Button ID="btnSave" runat="server" Text="💾 Kaydet" 
            CssClass="btn btn-primary" OnClick="btnSave_Click" />
        <asp:Button ID="btnCancel" runat="server" Text="❌ İptal" 
            CssClass="btn btn-secondary" OnClick="btnCancel_Click" 
            CausesValidation="false" />
    </div>
</asp:Content>