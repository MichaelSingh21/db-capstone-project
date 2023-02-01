#GetMaxQuantity

CREATE VIEW `GetMaxQuantity` AS
SELECT MAX(Quantity) as 'Max Quantity in Order' from orders 

#AddBooking
DELIMITER $$
CREATE DEFINER=`admin1`@`%` PROCEDURE `AddBooking`(IN inBookingID INT, IN inCustomerID INT, IN inBookingDate DATE, IN inTableNumber INT)
BEGIN
DECLARE AlreadyBooked INT DEFAULT 0;
SELECT COUNT(1) INTO AlreadyBooked FROM bookings where BookingDate = inBookingDate AND TableNo = inTableNumber;
START TRANSACTION;

INSERT INTO `littlelemondb`.`bookings` (`BookingID`, `TableNo`, `BookingSlot`, `BookingDate`, `StaffID`, `CustomerID`) 
VALUES (inBookingID, inTableNumber,'11', inBookingDate, '1', inCustomerID);
IF AlreadyBooked > 0 THEN
	SELECT CONCAT("Table ",tableRequested," is already booked - booking cancelled.") as 'Confirmation';
    ROLLBACK;
ELSE
	SELECT CONCAT("New booking added") as 'Confirmation';
	COMMIT;
END IF;
END$$
DELIMITER ;

#CancelBooking
DELIMITER $$
CREATE DEFINER=`admin1`@`%` PROCEDURE `CancelBooking`(IN inBookingID INT)
BEGIN
	DELETE FROM bookings where BookingID = inBookingID;
    SELECT CONCAT('Booking ',inBookingID,' cancelled.') as 'Confirmation';
END$$
DELIMITER ;

#UpdateBooking
DELIMITER $$
CREATE DEFINER=`admin1`@`%` PROCEDURE `UpdateBooking`(IN inBookingID INT, IN inBookingDate DATE)
BEGIN
	UPDATE bookings SET BookingDate = inBookingDate where BookingID = inBookingID;
    select CONCAT('Booking ',inBookingID,' updated') as 'Confirmation';
END$$
DELIMITER ;

#CheckBooking
DELIMITER $$
CREATE DEFINER=`admin1`@`%` PROCEDURE `CheckBooking`(IN bookingDate DATE, IN tableNumber int)
BEGIN
DECLARE AlreadyBooked INT DEFAULT 0;
SELECT CASE 
	WHEN COUNT(1) >= 1 THEN CONCAT("Table ",tableNumber," is already booked") 
    ELSE CONCAT("Table ", tableNumber, " is available on ", bookingDate)
    END as 'Booking status'
FROM bookings where bookings.BookingDate = bookingDate AND bookings.TableNo = tableNumber;
END$$
DELIMITER ;

