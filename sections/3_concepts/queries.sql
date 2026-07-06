
SELECT client_name, client_surname
FROM restaurants.clients
WHERE client_age = 18 ;


SELECT client_name, client_surname
FROM restaurants.clients
WHERE client_age BETWEEN 18 AND 25 ;
