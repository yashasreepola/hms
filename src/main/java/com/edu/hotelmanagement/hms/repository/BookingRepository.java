package com.edu.hotelmanagement.hms.repository;

import com.edu.hotelmanagement.hms.model.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
}