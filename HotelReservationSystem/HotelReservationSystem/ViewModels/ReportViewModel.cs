using System;

namespace HotelReservationSystem.ViewModels
{
    public class ReportViewModel
    {
        public int ReservationId { get; set; }
        public string CustomerName { get; set; }
        public string RoomNumber { get; set; }
        public DateTime CheckInDate { get; set; }
        public DateTime CheckOutDate { get; set; }
        public int TotalDays { get; set; }
        public decimal TotalPrice { get; set; }
        public string Status { get; set; }
    }
}