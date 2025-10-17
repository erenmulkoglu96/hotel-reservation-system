using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HotelReservationSystem.Models
{
    [Table("Rooms")]
    public class Room
    {
        [Key]
        public int RoomId { get; set; }

        [Required]
        [StringLength(10)]
        public string RoomNumber { get; set; }

        [Required]
        public int RoomTypeId { get; set; }

        [Required]
        public decimal Price { get; set; }

        [Required]
        public int Capacity { get; set; }

        [StringLength(500)]
        public string Description { get; set; }

        public bool IsActive { get; set; }

        // Navigation Properties
        [ForeignKey("RoomTypeId")]
        public virtual RoomType RoomType { get; set; }

        public virtual ICollection<Reservation> Reservations { get; set; }
    }
}