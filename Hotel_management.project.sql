create table guest_list (guest_ID int primary key ,first_name varchar(50), last_name varchar(50), email varchar(50), 
						phone_number varchar(15), address varchar(255), city varchar(50));
Create table booking ( booking_id int primary key ,guest_ID int, room_number int, check_in_date date, check_out_date date, 
						amount decimal(10,2), foreign key (guest_ID) references guest_list (guest_ID));
                        
######Inserting data in Tables
insert into guest_list (guest_ID,first_name, last_name, email, phone_number, address, city) values
('1','Ravi', 'Kumar', 'ravi.kumar@example.com', '9876543210', '123 MG Road', 'Bangalore'),
('2','Sita', 'Sharma', 'sita.sharma@example.com', '8765432109', '456 Park Street', 'Kolkata'),
('3','Anil', 'Mehta', 'anil.mehta@example.com', '7654321098', '789 Nehru Place', 'Delhi'),
('4','Pooja', 'Singh', 'pooja.singh@example.com', '6543210987', '101 Marine Drive', 'Mumbai'),
('5','Rahul', 'Patel', 'rahul.patel@example.com', '5432109876', '202 Ring Road', 'Ahmedabad'),
('6','Priya', 'Nair', 'priya.nair@example.com', '4321098765', '303 MG Road', 'Bangalore'),
('7','Vikas', 'Reddy', 'vikas.reddy@example.com', '3210987654', '404 Jubilee Hills', 'Mumbai'),
('8','Amit', 'Verma', 'amit.verma@example.com', '2109876543', '505 Civil Lines', 'Lucknow'),
('9','Kavita', 'Joshi', 'kavita.joshi@example.com', '1098765432', '606 Mall Road', 'Mumbai'),
('10','Sunil', 'Chopra', 'sunil.chopra@example.com', '1987654321', '707 Residency Road', 'Mumbai');

####### inserting data into table bookings
insert into booking (booking_id, guest_ID, room_number, check_in_date, check_out_date, amount) values 
(101, 1, 1, '2024-05-20', '2024-05-21', 900), 
(102, 2, 2, '2024-05-22', '2024-05-27', 900), 
(103, 3, 3, '2024-05-23', '2024-05-28', 1000), 
(104, 4, 4, '2024-05-24', '2024-05-24', 1000), 
(105, 5, 5, '2024-05-25', '2024-05-30', 1000), 
(106, 6, 6, '2024-05-26', '2024-05-26', 1000), 
(107, 7, 7, '2024-05-27', '2024-06-01', 1200), 
(108, 8, 8, '2024-05-28', '2024-06-02', 1200), 
(109, 9, 9, '2024-05-29', '2024-06-03', 1200), 
(110, 10, 10, '2024-05-30', '2024-06-04', 1200);
;




##################################################################################################################################
#Find the guest who has made the most bookings.  
WITH GuestBookings AS (
    SELECT
        Guest_list.guest_id,
        CONCAT(Guest_list.first_name, ' ', Guest_list.last_name) AS full_name,
        COUNT(Booking.booking_id) AS booking_count,
        sum(booking.amount) as total_amount_paid
    FROM
        Guest_list
    JOIN
        Booking
    ON
        Guest_list.guest_id = Booking.guest_id
    GROUP BY
        Guest_list.guest_id,
        Guest_list.first_name,
        Guest_list.last_name
),
RankedGuests AS (
    SELECT
        guest_id,
        full_name,
        booking_count,
        total_amount_paid,
        RANK() OVER (ORDER BY booking_count DESC) AS `rank`  -- Use backticks here
    FROM
        GuestBookings
)

SELECT
    guest_id,  -- Ensure consistency in case
    full_name,
    booking_count,
    total_amount_paid
FROM
    RankedGuests
WHERE
    `rank` = 1
    order by total_amount_paid asc;  -- Use backticks here as well
##################################################################################################################################
# Find the total revenue generated from all bookings.
select sum(amount) as total_amount from booking;
##################################################################################################################################
# List the guests who have bookings from 25-June to 1 -July.
SELECT DISTINCT g.Guest_id,
 CONCAT(first_name, ' ', last_name) AS Guest_Name
FROM guest_list G
INNER JOIN Booking b ON G.guest_ID = b.guest_ID
WHERE check_in_date BETWEEN '2024-05-25' AND '2024-06-01';
##################################################################################################################################
#Find the average stay duration of guests.
WITH Stay AS (
    SELECT
        CASE
            WHEN DATEDIFF(check_in_date, check_out_date) = 0
            THEN 1
            ELSE DATEDIFF(check_out_date, check_in_date)
        END AS stay_duration
    FROM
        Booking
)
SELECT
    FORMAT(AVG(stay_duration * 1.0), 'N2') AS average_stay_duration
FROM
    Stay;
##################################################################################################################################
#List the top 2 guests by total amount spent.
SELECT 
    G.guest_id,
    CONCAT(G.first_name, ' ', G.last_name) AS full_name,
    SUM(CASE
            WHEN DATEDIFF(check_out_date, check_in_date) = 0
            THEN 1
            ELSE DATEDIFF(check_out_date, check_in_date)
            END * b.amount) AS total_amount_spent
FROM Guest_list G
INNER JOIN Booking b ON G.guest_id = b.guest_id
GROUP BY G.guest_id, G.first_name, G.last_name
ORDER BY total_amount_spent DESC
limit 2;
##################################################################################################################################
#find the city from where the most guests have stayed
SELECT 
    G.city,
    COUNT(G.guest_id) AS guest_count
FROM  Guest_list G
INNER JOIN Booking B
ON G.guest_id = B.guest_id
GROUP BY G.city
ORDER BY guest_count DESC
limit 3;
