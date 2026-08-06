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
