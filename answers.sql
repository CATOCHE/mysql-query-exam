/*
1) Select a distinct list of ordered airports codes.
*/
SELECT DISTINCT departAirport Airports FROM flight;

/*
2) Provide a list of delayed flights departing from San Francisco (SFO).
*/
SELECT a.name, f.flightNumber, f.scheduledDepartDateTime, f.arriveAirport, f.status
FROM flight f INNER JOIN airline a ON f.airlineID = a.ID
WHERE f.status = 'delayed' AND f.departAirport = 'SFO';

/*
3) Provide a distinct list of cities that American airlines departs from.
*/
SELECT DISTINCT f.departAirport Cities
FROM flight f INNER JOIN airline a ON f.airlineID = a.ID
WHERE a.name = 'American';

/*
4) Provide a distinct list of airlines that conducts flights departing from ATL.
*/
SELECT DISTINCT a.name Airline
FROM flight f INNER JOIN airline a ON f.airlineID = a.ID
WHERE f.departAirport = 'ATL';

/*
5) Provide a list of airlines, flight numbers, departing airports, and arrival
airports where flights departed on time.
*/
SELECT name, flightNumber, departAirport, arriveAirport
FROM flight f INNER JOIN airline a ON f.airlineID = a.ID
WHERE scheduledDepartDateTime = actualDepartDateTime;

/*
6) Provide a list of airlines, flight numbers, gates, status, and arrival times
arriving into Charlotte (CLT) on 10-30-2017.
*/
SELECT a.name Airline, f.flightNumber Flight, f.gate Gate,
TIME(f.scheduledArriveDateTime) Arrival, f.status Status
FROM flight f INNER JOIN airline a ON f.airlineID = a.ID
WHERE arriveAirport = 'CLT' AND DATE(scheduledArriveDateTime) = '2017-10-30'
ORDER by Arrival;

/*
7) List the number of reservations by flight number. Order by reservations
in descending order.
*/
SELECT f.flightNumber flight, COUNT(r.passengerID) reservations
FROM reservation r INNER JOIN flight f ON r.flightID = f.ID
GROUP BY f.flightNumber
ORDER BY reservations DESC;

/*
8) List the average ticket cost for coach by airline and route. Order by
AverageCost in descending order.
*/
SELECT DISTINCT a.name airline, departAirport, arriveAirport, AVG(r.cost) AverageCost
FROM flight f
INNER JOIN reservation r ON f.ID = r.flightID
INNER JOIN airline a ON f.airlineID = a.ID
WHERE r.class = 'coach'
GROUP BY f.ID
ORDER BY AVG(r.cost) DESC;

/*
9) Which route is the longest?
*/
SELECT departAirport, arriveAirport, miles
FROM flight ORDER BY miles DESC LIMIT 1;

/*
10) List the top 5 passengers that have flown the most miles. Order by miles.
*/
SELECT firstName, lastName, SUM(f.miles) miles
FROM reservation r
INNER JOIN passenger p ON r.passengerID = p.ID
INNER JOIN flight f ON r.flightID = f.ID
GROUP BY p.ID
ORDER BY miles DESC, firstName
LIMIT 5;

/*
11) Provide a list of American airline flights ordered by route and arrival
date and time.
*/
SELECT a.name Name, CONCAT(departAirport,' --> ', arriveAirport) Route,
DATE(scheduledArriveDateTime) 'Arrive Date',
TIME(scheduledArriveDateTime)  'Arrive Time'
FROM flight f
INNER JOIN airline a ON f.airlineID = a.ID
WHERE a.name = 'American'
ORDER BY Route, DATE(scheduledArriveDateTime), TIME(scheduledArriveDateTime);

/*
12) Provide a report that counts the number of reservations and totals the
reservation costs (as Revenue) by Airline, flight, and route.
Order the report by total revenue in descending order.
*/
SELECT a.name Airline, f.flightNumber Flight,
CONCAT(departAirport,' --> ', arriveAirport) Route,
COUNT(r.passengerID) 'Reservation Count',
SUM(r.cost) Revenue
FROM reservation r
INNER JOIN flight f ON r.flightID = f.ID
INNER JOIN airline a ON f.airlineID = a.ID
GROUP BY a.name, Flight, Route
ORDER BY Revenue DESC;

/*
13) List the average cost per reservation by route. Round results down to the dollar.
*/
SELECT DISTINCT CONCAT(f.departAirport,' --> ', f.arriveAirport) Route,
TRUNCATE(AVG(r.cost),0) 'Avg Revenue'
FROM flight f
INNER JOIN reservation r ON f.ID = r.flightID
GROUP BY Route
ORDER BY AVG(r.cost) DESC;

/*
14) List the average miles per flight by airline.
*/
SELECT a.name Airline, AVG(f.miles) 'Avg Miles Per Flight'
FROM flight f
INNER JOIN airline a ON f.airlineID = a.ID
GROUP BY a.name;

/*
15) Which airlines had flights that arrived early?
*/
SELECT DISTINCT a.name Airline
FROM flight f
INNER JOIN airline a ON f.airlineID = a.ID
WHERE f.actualArriveDateTime IS NOT NULL
AND f.actualArriveDateTime < f.scheduledArriveDateTime;
