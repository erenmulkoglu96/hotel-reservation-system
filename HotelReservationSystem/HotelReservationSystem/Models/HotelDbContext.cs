using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;


namespace HotelReservationSystem.Models
{
    public class HotelDbContext:DbContext
    {

        public HotelDbContext():base("name=HotelConnectionString")
        {

        }

        public DbSet<RoomType>RoomTypes { get; set; }
        public DbSet<Room> Rooms { get; set; }
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Reservation>Reservations { get; set; }
        public DbSet<User>Users { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            //Decimal precision ayarları
            modelBuilder.Entity<Room>()
                .Property(r => r.Price)
                .HasPrecision(10, 2);
            modelBuilder.Entity<Reservation>()
                .Property(r => r.TotalPrice)
                .HasPrecision(10, 2);
            base.OnModelCreating(modelBuilder);
        }

    }
}