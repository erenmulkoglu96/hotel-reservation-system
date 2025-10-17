using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using Telerik.Web.UI;
using HotelReservationSystem.Models;
using HotelReservationSystem.ViewModels;


namespace HotelReservationSystem.Admin
{
    public partial class Reports : BasePage
    {
        private List<ReportViewModel> _reportData;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rdpStartDate.SelectedDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                rdpEndDate.SelectedDate = DateTime.Now;
            }
        }
        protected void btnGenerateReport_Click(object sender, EventArgs e)
        {
            if (!rdpStartDate.SelectedDate.HasValue || !rdpEndDate.SelectedDate.HasValue)
            {
                return;
            }

            DateTime startDate = rdpStartDate.SelectedDate.Value;
            DateTime endDate = rdpEndDate.SelectedDate.Value.AddDays(1); 

            GenerateReport(startDate, endDate);
        }
        private void GenerateReport(DateTime startDate, DateTime endDate)
        {
            using (var db = new HotelDbContext())
            {
                var reservations = db.Reservations
                    .Include("Customer")
                    .Include("Room")
                    .Include("Room.RoomType")
                    .Where(r => r.CreatedDate >= startDate &&
                               r.CreatedDate < endDate &&
                               r.Status != "Cancelled")
                    .ToList();

                if (!reservations.Any())
                {
                    pnlSummary.Visible = false;
                    pnlTopRooms.Visible = false;
                    pnlDetailedReport.Visible = false;
                    pnlNoData.Visible = true;
                    return;
                }

                LoadSummaryStatistics(reservations, startDate, endDate);

                LoadTopRooms(reservations);

                PrepareDetailedReport(reservations);

                pnlSummary.Visible = true;
                pnlTopRooms.Visible = true;
                pnlDetailedReport.Visible = true;
                pnlNoData.Visible = false;
            }
        }
        private void LoadSummaryStatistics(List<Reservation> reservations, DateTime startDate, DateTime endDate)
        {
            decimal totalRevenue = reservations.Sum(r => r.TotalPrice);
            lblTotalRevenue.Text = totalRevenue.ToString("N0");
            lblRevenueSubtitle.Text = $"{startDate:dd.MM.yyyy} - {endDate.AddDays(-1):dd.MM.yyyy}";

            int totalReservations = reservations.Count;
            lblTotalReservations.Text = totalReservations.ToString();
            lblReservationSubtitle.Text = $"{reservations.Count(r => r.Status == "Confirmed")} onaylı";

            int daysDifference = (endDate - startDate).Days;
            using (var db = new HotelDbContext())
            {
                int totalRooms = db.Rooms.Count(r => r.IsActive);
                int totalPossibleRoomDays = totalRooms * daysDifference;
                int totalReservedDays = reservations.Sum(r => r.TotalDays);

                double occupancyRate = totalPossibleRoomDays > 0
                    ? (double)totalReservedDays / totalPossibleRoomDays * 100
                    : 0;

                lblOccupancyRate.Text = occupancyRate.ToString("N1");
                lblOccupancySubtitle.Text = $"{totalReservedDays} / {totalPossibleRoomDays} gün";
            }

            decimal averageRevenue = totalReservations > 0
                ? totalRevenue / totalReservations
                : 0;
            lblAverageRevenue.Text = averageRevenue.ToString("N0");
        }
        private void LoadTopRooms(List<Reservation> reservations)
        {
            var topRooms = reservations
                .GroupBy(r => new {
                    r.Room.RoomNumber,
                    RoomTypeName = r.Room.RoomType.TypeName
                })
                .Select(g => new
                {
                    RoomNumber = g.Key.RoomNumber,
                    RoomTypeName = g.Key.RoomTypeName,
                    ReservationCount = g.Count(),
                    TotalRevenue = g.Sum(r => r.TotalPrice),
                    AveragePrice = g.Average(r => r.TotalPrice)
                })
                .OrderByDescending(x => x.ReservationCount)
                .Take(10)
                .ToList();

            RadGridTopRooms.DataSource = topRooms;
            RadGridTopRooms.DataBind();
        }

        private void PrepareDetailedReport(List<Reservation> reservations)
        {
            _reportData = reservations
                .Select(r => new ReportViewModel  
                {
                    ReservationId = r.ReservationId,
                    CustomerName = r.Customer.FullName,
                    RoomNumber = r.Room.RoomNumber,
                    CheckInDate = r.CheckInDate,
                    CheckOutDate = r.CheckOutDate,
                    TotalDays = r.TotalDays,
                    TotalPrice = r.TotalPrice,
                    Status = GetStatusText(r.Status)
                })
                .OrderByDescending(r => r.CheckInDate)
                .ToList();

            Session["ReportData"] = _reportData;
        }

        protected void RadGridDetailed_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            if (Session["ReportData"] != null)
            {
                RadGridDetailed.DataSource = Session["ReportData"];
            }
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            if (Session["ReportData"] == null)
                return;

            var reportData = (List<ReportViewModel>)Session["ReportData"];
            DateTime startDate = rdpStartDate.SelectedDate ?? DateTime.Now.AddMonths(-1);
            DateTime endDate = rdpEndDate.SelectedDate ?? DateTime.Now;

            var html = new System.Text.StringBuilder();

            html.AppendLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            html.AppendLine("<?mso-application progid=\"Excel.Sheet\"?>");
            html.AppendLine("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
            html.AppendLine(" xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
            html.AppendLine(" xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
            html.AppendLine(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
            html.AppendLine(" xmlns:html=\"http://www.w3.org/TR/REC-html40\">");

            html.AppendLine("<Styles>");

            html.AppendLine("<Style ss:ID=\"Header\">");
            html.AppendLine("<Font ss:Bold=\"1\" ss:Color=\"#FFFFFF\"/>");
            html.AppendLine("<Interior ss:Color=\"#4472C4\" ss:Pattern=\"Solid\"/>");
            html.AppendLine("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
            html.AppendLine("<Borders>");
            html.AppendLine("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            html.AppendLine("</Borders>");
            html.AppendLine("</Style>");

            html.AppendLine("<Style ss:ID=\"Info\">");
            html.AppendLine("<Interior ss:Color=\"#F2F2F2\" ss:Pattern=\"Solid\"/>");
            html.AppendLine("<Borders>");
            html.AppendLine("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\" ss:Color=\"#4472C4\"/>");
            html.AppendLine("</Borders>");
            html.AppendLine("</Style>");

            html.AppendLine("<Style ss:ID=\"Number\">");
            html.AppendLine("<Alignment ss:Horizontal=\"Center\"/>");
            html.AppendLine("</Style>");

            html.AppendLine("<Style ss:ID=\"Price\">");
            html.AppendLine("<NumberFormat ss:Format=\"#,##0.00\"/>");
            html.AppendLine("<Alignment ss:Horizontal=\"Right\"/>");
            html.AppendLine("<Font ss:Bold=\"1\" ss:Color=\"#00B050\"/>");
            html.AppendLine("</Style>");

            html.AppendLine("<Style ss:ID=\"Total\">");
            html.AppendLine("<Interior ss:Color=\"#E7E6E6\" ss:Pattern=\"Solid\"/>");
            html.AppendLine("<Font ss:Bold=\"1\"/>");
            html.AppendLine("</Style>");

            html.AppendLine("</Styles>");

            html.AppendLine("<Worksheet ss:Name=\"Rezervasyon Raporu\">");
            html.AppendLine("<Table>");

            html.AppendLine("<Column ss:Width=\"50\"/>");  
            html.AppendLine("<Column ss:Width=\"150\"/>");  
            html.AppendLine("<Column ss:Width=\"60\"/>");  
            html.AppendLine("<Column ss:Width=\"90\"/>");   
            html.AppendLine("<Column ss:Width=\"90\"/>");  
            html.AppendLine("<Column ss:Width=\"50\"/>");   
            html.AppendLine("<Column ss:Width=\"100\"/>");  
            html.AppendLine("<Column ss:Width=\"80\"/>");   

            html.AppendLine("<Row ss:Height=\"30\">");
            html.AppendLine("<Cell ss:MergeAcross=\"7\" ss:StyleID=\"Header\">");
            html.AppendLine("<Data ss:Type=\"String\">🏨 Rezervasyon Raporu</Data>");
            html.AppendLine("</Cell>");
            html.AppendLine("</Row>");

            html.AppendLine("<Row ss:Height=\"25\">");
            html.AppendLine("<Cell ss:MergeAcross=\"7\" ss:StyleID=\"Info\">");
            html.AppendLine($"<Data ss:Type=\"String\">Tarih Aralığı: {startDate:dd.MM.yyyy} - {endDate:dd.MM.yyyy} | Oluşturma: {DateTime.Now:dd.MM.yyyy HH:mm} | Kayıt: {reportData.Count} adet</Data>");
            html.AppendLine("</Cell>");
            html.AppendLine("</Row>");

            html.AppendLine("<Row/>");

            html.AppendLine("<Row ss:Height=\"25\">");
            html.AppendLine("<Cell ss:StyleID=\"Header\"><Data ss:Type=\"String\">ID</Data></Cell>");
            html.AppendLine("<Cell ss:StyleID=\"Header\"><Data ss:Type=\"String\">Müşteri</Data></Cell>");
            html.AppendLine("<Cell ss:StyleID=\"Header\"><Data ss:Type=\"String\">Oda</Data></Cell>");
            html.AppendLine("<Cell ss:StyleID=\"Header\"><Data ss:Type=\"String\">Giriş</Data></Cell>");
            html.AppendLine("<Cell ss:StyleID=\"Header\"><Data ss:Type=\"String\">Çıkış</Data></Cell>");
            html.AppendLine("<Cell ss:StyleID=\"Header\"><Data ss:Type=\"String\">Gün</Data></Cell>");
            html.AppendLine("<Cell ss:StyleID=\"Header\"><Data ss:Type=\"String\">Tutar (₺)</Data></Cell>");
            html.AppendLine("<Cell ss:StyleID=\"Header\"><Data ss:Type=\"String\">Durum</Data></Cell>");
            html.AppendLine("</Row>");

            decimal totalRevenue = 0;
            int totalDays = 0;

            foreach (var item in reportData)
            {
                totalRevenue += item.TotalPrice;
                totalDays += item.TotalDays;

                html.AppendLine("<Row>");
                html.AppendLine($"<Cell ss:StyleID=\"Number\"><Data ss:Type=\"Number\">{item.ReservationId}</Data></Cell>");
                html.AppendLine($"<Cell><Data ss:Type=\"String\">{item.CustomerName}</Data></Cell>");
                html.AppendLine($"<Cell ss:StyleID=\"Number\"><Data ss:Type=\"String\">{item.RoomNumber}</Data></Cell>");
                html.AppendLine($"<Cell ss:StyleID=\"Number\"><Data ss:Type=\"String\">{item.CheckInDate:dd.MM.yyyy}</Data></Cell>");
                html.AppendLine($"<Cell ss:StyleID=\"Number\"><Data ss:Type=\"String\">{item.CheckOutDate:dd.MM.yyyy}</Data></Cell>");
                html.AppendLine($"<Cell ss:StyleID=\"Number\"><Data ss:Type=\"Number\">{item.TotalDays}</Data></Cell>");
                html.AppendLine($"<Cell ss:StyleID=\"Price\"><Data ss:Type=\"Number\">{item.TotalPrice}</Data></Cell>");
                html.AppendLine($"<Cell ss:StyleID=\"Number\"><Data ss:Type=\"String\">{item.Status}</Data></Cell>");
                html.AppendLine("</Row>");
            }

            html.AppendLine("<Row ss:Height=\"25\">");
            html.AppendLine("<Cell ss:MergeAcross=\"4\" ss:StyleID=\"Total\">");
            html.AppendLine("<Data ss:Type=\"String\">TOPLAM:</Data>");
            html.AppendLine("</Cell>");
            html.AppendLine($"<Cell ss:StyleID=\"Total\"><Data ss:Type=\"Number\">{totalDays}</Data></Cell>");
            html.AppendLine($"<Cell ss:StyleID=\"Total\"><Data ss:Type=\"Number\">{totalRevenue}</Data></Cell>");
            html.AppendLine("<Cell ss:StyleID=\"Total\"/>");
            html.AppendLine("</Row>");

            html.AppendLine("</Table>");
            html.AppendLine("</Worksheet>");
            html.AppendLine("</Workbook>");

            Response.Clear();
            Response.ContentType = "application/vnd.ms-excel";
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.AddHeader("content-disposition",
                $"attachment;filename=Rezervasyon_Raporu_{startDate:yyyyMMdd}_{endDate:yyyyMMdd}.xls");

            byte[] bom = { 0xEF, 0xBB, 0xBF };
            Response.BinaryWrite(bom);
            Response.Write(html.ToString());
            Response.Flush();
            Response.End();
        }

        private string GetStatusText(string status)
        {
            switch (status)
            {
                case "Pending": return "Bekleyen";
                case "Confirmed": return "Onaylı";
                case "Cancelled": return "İptal";
                case "Completed": return "Tamamlandı";
                default: return status;
            }
        }
       }
}