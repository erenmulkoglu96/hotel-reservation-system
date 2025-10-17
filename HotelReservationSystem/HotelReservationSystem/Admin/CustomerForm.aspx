<%@ Page Title="Müşteri Ekle/Düzenle" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerForm.aspx.cs" Inherits="HotelReservationSystem.Admin.CustomerForm" %>

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
        input[type="email"],
        input[type="tel"] {
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
            background-color: #28a745;
            color: white;
        }
        .btn-primary:hover {
            background-color: #218838;
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
        .form-row {
            display: flex;
            gap: 20px;
        }
        .form-row .form-group {
            flex: 1;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 style="color: #333; border-bottom: 3px solid #28a745; padding-bottom: 10px; margin-bottom: 30px;">
        <asp:Literal ID="litTitle" runat="server" Text="👥 Yeni Müşteri Ekle"></asp:Literal>
    </h1>

    <asp:Panel ID="pnlMessage" runat="server" Visible="false">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
    </asp:Panel>

    <div class="form-row">
        <div class="form-group">
            <label>Ad <span class="required">*</span></label>
            <asp:TextBox ID="txtFirstName" runat="server" MaxLength="50" placeholder="Örn: Ahmet"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" 
                ControlToValidate="txtFirstName"
                ErrorMessage="Ad zorunludur!" 
                CssClass="error" Display="Dynamic">
            </asp:RequiredFieldValidator>
        </div>

        <div class="form-group">
            <label>Soyad <span class="required">*</span></label>
            <asp:TextBox ID="txtLastName" runat="server" MaxLength="50" placeholder="Örn: Yılmaz"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvLastName" runat="server" 
                ControlToValidate="txtLastName"
                ErrorMessage="Soyad zorunludur!" 
                CssClass="error" Display="Dynamic">
            </asp:RequiredFieldValidator>
        </div>
    </div>
    <div class="form-group">
        <label>E-posta <span class="required">*</span></label>
        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" MaxLength="100" 
            placeholder="ornek@email.com"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
            ControlToValidate="txtEmail"
            ErrorMessage="E-posta zorunludur!" 
            CssClass="error" Display="Dynamic">
        </asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="revEmail" runat="server"
            ControlToValidate="txtEmail"
            ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"
            ErrorMessage="Geçerli bir e-posta adresi giriniz!"
            CssClass="error" Display="Dynamic">
        </asp:RegularExpressionValidator>
    </div>

    <div class="form-row">
        <div class="form-group">
            <label>Telefon</label>
            <asp:TextBox ID="txtPhone" runat="server" TextMode="Phone" MaxLength="20" 
                placeholder="0555 123 45 67"></asp:TextBox>
        </div>
        <div class="form-group">
            <label>TC Kimlik No</label>
            <asp:TextBox ID="txtIdentityNumber" runat="server" MaxLength="11" 
                placeholder="12345678901"></asp:TextBox>
            <asp:RegularExpressionValidator ID="revIdentity" runat="server"
                ControlToValidate="txtIdentityNumber"
                ValidationExpression="^\d{11}$"
                ErrorMessage="TC Kimlik 11 rakam olmalıdır!"
                CssClass="error" Display="Dynamic">
            </asp:RegularExpressionValidator>
        </div>
    </div>
    <div class="button-group">
        <asp:Button ID="btnSave" runat="server" Text="💾 Kaydet" 
            CssClass="btn btn-primary" OnClick="btnSave_Click" />
        <asp:Button ID="btnCancel" runat="server" Text="❌ İptal" 
            CssClass="btn btn-secondary" OnClick="btnCancel_Click" 
            CausesValidation="false" />
    </div>
</asp:Content>