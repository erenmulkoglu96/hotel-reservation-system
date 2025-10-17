using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace HotelReservationSystem.Models
{
    [Table("RoomTypes")]
    public class RoomType
    {
        [Key]
        public int RoomTypeId { get; set; }

        [Required]
        [StringLength(50)]
        public string TypeName { get; set; }

        public string Description { get; set; }

        //Navigation Property
        public virtual ICollection<Room> Rooms { get; set; }
    }
}