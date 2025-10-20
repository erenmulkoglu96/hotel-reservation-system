# Otel Rezervasyon Sistemi


Modern ve kullanıcı dostu otel yönetim sistemi. ASP.NET Web Forms, Entity Framework ve Telerik UI ile geliştirilmiştir.


## Özellikler

- **Oda Yönetimi**: Oda ekleme, düzenleme, silme ve fiyatlandırma

- **Müşteri Yönetimi**: Müşteri kayıtları ve geçmiş takibi

- **Rezervasyon Yönetimi**: Rezervasyon oluşturma, onaylama, iptal etme

- **Raporlar**: Gelir, doluluk oranı ve detaylı istatistikler

- **Güvenli Giriş**: Admin paneli için kimlik doğrulama

- **Responsive Tasarım**: Tüm cihazlarda uyumlu arayüz



## Kullanılan Teknolojiler

- **Backend**: ASP.NET Web Forms, C# .NET Framework 4.8

- **ORM**: Entity Framework 6

- **Database**: SQL Server

- **UI Components**: Telerik UI for ASP.NET AJAX

- **Frontend**: HTML5, CSS3, JavaScript




## Kurulum


1. **Projeyi Klonlayın**

```bash
   git clone https://github.com/erenmulkoglu96/HotelReservationSystem.git
   cd HotelReservationSystem
```

2. **Web.config'i Düzenleyin**
   - `Web.config` dosyasını açın
   - Connection string'i kendi SQL Server bilgilerinizle güncelleyin

3. **NuGet Paketlerini Yükleyin**
   - Visual Studio'da projeyi açın
   - Tools → NuGet Package Manager → Package Manager Console
   - `Update-Package` komutunu çalıştırın



## Varsayılan Admin Girişi

- **Kullanıcı Adı**: `admin`
- **Şifre**: `admin123`



## Ekran Görüntüleri


<div align="center">
  <table>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/24ee974d-63f7-407c-b288-7cd2ffacef9e" width="400"/></td>
      <td><img src="https://github.com/user-attachments/assets/c19e75fd-ae3a-423a-8203-8cb7f7d0bf66" width="400"/></td>
    </tr>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/7827a18d-4b8b-4b08-a828-a56c62b98032" width="400"/></td>
      <td><img src="https://github.com/user-attachments/assets/9bff80dc-3631-4052-ac65-a37675927c01" width="400"/></td>
    </tr>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/b0862724-0e47-478d-9a62-5a599accee6f" width="400"/></td>
      <td><img src="https://github.com/user-attachments/assets/cbd4d912-9262-4a37-a04d-d5d8eb2385ff" width="400"/></td>
    </tr>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/af07b40f-198e-424a-bdb8-6e5d5c76a55a" width="400"/></td>
      <td><img src="https://github.com/user-attachments/assets/a35cfc78-538d-4934-bf5e-063ca05acf52" width="400"/></td>
    </tr>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/80f0a291-8ce1-4130-8f40-f446c79e149c" width="400"/></td>
      <td><img src="https://github.com/user-attachments/assets/46ce63e6-c464-47da-bfaa-76aca6b6ae40" width="400"/></td>
    </tr>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/97fe8afe-fd20-4b8f-98e5-a4c086686f47" width="400"/></td>
      <td><img src="https://github.com/user-attachments/assets/8d51358a-d2aa-432a-b382-663425de4caa" width="400"/></td>
    </tr>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/12ee0b75-535c-4dde-bace-2f94238d34fb" width="400"/></td>
      <td><img src="https://github.com/user-attachments/assets/b2ab7d63-3f43-43b8-b505-1a26244d0085" width="400"/></td>
    </tr>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/d16400ca-bf56-48a4-af15-a998a602950b" width="400"/></td>
      <td><img src="https://github.com/user-attachments/assets/19b5a59e-9d7d-4958-9435-d2e476a2820b" width="400"/></td>
    </tr>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/54a94c8a-312b-42ff-baad-41d4c62f3ac4" width="400"/></td>
      <td><img src="https://github.com/user-attachments/assets/d0c51a61-16c3-41a3-ab5f-c07eddc29ca9" width="400"/></td>
    </tr>
    <tr>
      <td colspan="2" align="center"><img src="https://github.com/user-attachments/assets/05cc46b7-b530-4743-b49e-b188555127b4" width="400"/></td>
    </tr>
  </table>
</div>



## Proje Yapısı
```
HotelReservationSystem/
├── Admin/                  # Admin panel sayfaları
│   ├── CustomerList.aspx   # Müşteri listesi
│   ├── RoomList.aspx       # Oda listesi
│   ├── ReservationList.aspx # Rezervasyon listesi
│   ├── Reports.aspx        # Raporlar
│   ├── About.aspx          # Hakkımızda
│   └── Contact.aspx        # İletişim
├── Models/                 # Entity Framework modelleri
│   ├── Customer.cs
│   ├── Room.cs
│   ├── Reservation.cs
│   └── HotelDbContext.cs
├── Database/               # Veritabanı scriptleri
│   └── CreateDatabase.sql
├── Content/                # CSS ve görseller
├── Scripts/                # JavaScript dosyaları
├── Site.Master             # Master page
├── Login.aspx              # Giriş sayfası
└── Default.aspx            # Ana sayfa
```

































