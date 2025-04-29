
SELECT *
FROM flights;


SELECT *
FROM airports;

SELECT *
FROM cancellation_codes;

SELECT *
FROM airlines;




-- What are the top 5 most common origin-to-destination routes?

	SELECT origin_airport,
			destination_airport,
			count(*) as common_routes
	FROM flights
	GROUP BY 1,2
	ORDER BY 3 DESC
	LIMIT 5;

-- What is the average arrival delay for each airline?

SELECT a.airline,
		Round(AVG(f.departure_delay)) as AVG_delay
FROM flights f
	JOIN 
	airlines a
on f.airline = a.iata_code
GROUP BY 1;



-- Which 3 airports have the most departing flights?
SELECT ap.airport,
		count(*) as departures
FROM flights f JOIN airports ap
on f.origin_airport = ap.iata_code
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

-- How many flights were cancelled for each cancellation reason?

SELECT cc.cancellation_description,
		count(f.*) as total_cancelled
FROM cancellation_codes cc JOIN flights f
on cc.cancellation_reason = f.cancellation_reason
GROUP BY 1;

-- Which airline has the highest average delay?

SELECT a.airline,
		Round(AVG(f.departure_delay)) as AVG_delay
FROM flights f
	JOIN 
	airlines a
on f.airline = a.iata_code
GROUP BY 1
ORDER BY 2 Desc
LIMIT 1;

-- What percentage of flights were delayed for each airline?
SELECT a.airline,
		count(case when f.arrival_delay >0 then 1 END)* 100/count(*) delayed_percentage
FROM flights f
	JOIN 
	airlines a
on f.airline = a.iata_code
GROUP BY 1;


-- What is the average delay per destination airport?

SELECT destination_airport,
		Round(AVG(departure_delay)) as avg_deleay
FROM flights
GROUP BY 1;

-- How many flights were operated by each airline?

SELECT al.airline,
		count(*) as total_flights
FROM flights f
		JOIN
		airlines al
on f.airline = al.iata_code
GROUP BY 1;


-- For each airline, what is the most common reason for cancellation?
SELECT airline, cancellation_description, total
FROM
(SELECT al.airline,
		cc.cancellation_description,
		count(*) as total,
		Rank() over(PARTITION BY al.airline ORDER BY count(*) DESC) as rnk
FROM flights f JOIN airlines al
on f.airline = al.iata_code 
		JOIN
		cancellation_codes cc
on cc.cancellation_reason = f.cancellation_reason
WHERE f.cancelled = 1
group by 1,2) as ranked
WHERE rnk = 1;


-- How many flights were operated on each day?

SELECT departure_time AS flight_date, COUNT(*) AS daily_flights
FROM flights
WHERE departure_time IS NOT NULL
GROUP BY flight_date;






