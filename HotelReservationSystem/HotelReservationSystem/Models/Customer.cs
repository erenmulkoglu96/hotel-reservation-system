using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace HotelReservationSystem.Models
{

    [Table("Customers")]
    public class Customer
    {

        [Key]
        public int CustomerId { get; set; }

        [Required]
        [StringLength(50)]
        public string FirstName { get; set; }

        [Required]
        [StringLength(50)]
        public string LastName { get; set; }

        [Required]
        [StringLength(100)]
        [EmailAddress]
        public string Email {get;set;}

        [StringLength(20)]
        public string Phone { get; set; }

        [StringLength(11)]
        public string IdentityNumber { get; set; }

        public DateTime CreatedDate { get; set; }

        public virtual ICollection<Reservation> Reservations { get; set; }

        [NotMapped]
        public string FullName => $"{FirstName} {LastName}";
    }
}