package com.edu.hotelmanagement.hms;

import com.edu.hotelmanagement.hms.controller.BookingController;
import com.edu.hotelmanagement.hms.model.Booking;
import com.edu.hotelmanagement.hms.repository.BookingRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.util.Optional;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

// CRITICAL: This annotation ensures we DO NOT load the database/Spring Context
@ExtendWith(MockitoExtension.class)
class BookingControllerTest {

    @Mock
    private BookingRepository bookingRepository;

    @InjectMocks
    private BookingController bookingController;

    @Test
    void testGetBookingById() {
        // Arrange
        Booking mockBooking = new Booking(1L, "John Doe", "Deluxe", null, null, 100.0);
        when(bookingRepository.findById(1L)).thenReturn(Optional.of(mockBooking));

        // Act
        ResponseEntity<Booking> response = bookingController.getBookingById(1L);

        // Assert
        assertEquals(200, response.getStatusCodeValue());
        assertEquals("John Doe", response.getBody().getGuestName());
    }
}