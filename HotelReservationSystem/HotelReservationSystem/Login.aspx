<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="HotelReservationSystem.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Giriş Yap - Otel Rezervasyon Sistemi</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .login-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            overflow: hidden;
            width: 100%;
            max-width: 400px;
        }
        .login-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }
        .login-header h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        .login-header .icon {
            font-size: 50px;
            margin-bottom: 15px;
        }
        .login-header p {
            opacity: 0.9;
            font-size: 14px;
        }
        .login-body {
            padding: 40px 30px;
        }

        .form-group {
            margin-bottom: 25px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }
        .form-group .input-wrapper {
            position: relative;
        }
        .form-group input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 2px solid #e1e8ed;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .form-group .icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            color: #999;
        }
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-login:active {
            transform: translateY(0);
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
            font-size: 14px;
        }
        .info-box {
            background-color: #d1ecf1;
            color: #0c5460;
            padding: 15px;
            border-radius: 8px;
            margin-top: 25px;
            font-size: 13px;
            text-align: center;
        }
        .info-box strong {
            display: block;
            margin-bottom: 5px;
        }
        .validator {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: block;
        }
        .login-footer {
            background-color: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #6c757d;
            font-size: 13px;
        }
        @media (max-width: 480px) {
            .login-container {
                margin: 0 10px;
            }            
            .login-header {
                padding: 30px 20px;
            }
            .login-body {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="login-header">
                <div class="icon">🏨</div>
                <h1>Hoş Geldiniz</h1>
                <p>Otel Rezervasyon Yönetim Sistemi</p>
            </div>

            <div class="login-body">
                <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="error-message">
                    <asp:Label ID="lblError" runat="server"></asp:Label>
                </asp:Panel>

                <div class="form-group">
                    <label>Kullanıcı Adı</label>
                    <div class="input-wrapper">
                        <span class="icon">👤</span>
                        <asp:TextBox ID="txtUsername" runat="server" 
                            placeholder="Kullanıcı adınızı girin"
                            MaxLength="50">
                        </asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                        ControlToValidate="txtUsername"
                        ErrorMessage="Kullanıcı adı zorunludur!"
                        CssClass="validator" Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label>Şifre</label>
                    <div class="input-wrapper">
                        <span class="icon">🔒</span>
                        <asp:TextBox ID="txtPassword" runat="server" 
                            TextMode="Password"
                            placeholder="Şifrenizi girin"
                            MaxLength="50">
                        </asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Şifre zorunludur!"
                        CssClass="validator" Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <asp:Button ID="btnLogin" runat="server" 
                    Text="🔓 Giriş Yap" 
                    CssClass="btn-login" 
                    OnClick="btnLogin_Click" />

                <div class="info-box">
                    <strong>💡 Test Kullanıcı Bilgileri:</strong>
                    Kullanıcı Adı: <strong>admin</strong><br />
                    Şifre: <strong>admin123</strong>
                </div>
            </div>

            <div class="login-footer">
                © <%= DateTime.Now.Year %> Otel Rezervasyon Sistemi
            </div>
        </div>
    </form>
</body>
</html>