-- Query the total number of violations in each district
SELECT district_name, COUNT(*) AS violation_count
FROM violation
GROUP BY district_name
ORDER BY violation_count DESC;

-- Query the average fine amount of each camera
SELECT camera_id, AVG(fine) AS average_fine
FROM violation
GROUP BY camera_id
ORDER BY average_fine DESC;

-- Query the license plate number and owner phone of the car that ran the red light at the highest speed
SELECT v.plate_number, c.owner_phone
FROM violation v
JOIN road r ON v.road_name = r.r_name AND v.district_name = r.district_name
JOIN car c ON v.plate_number = c.plate_number
WHERE r.speed_limit = (SELECT MIN(speed_limit) FROM road);

-- Query the name and phone of the driver who ran the red light the most times
SELECT d.driver_name, d.phone
FROM driver d
JOIN driving dr ON d.id = dr.driver_id
JOIN violation v ON dr.plate_number = v.plate_number 
AND v.violation_time BETWEEN dr.start_time AND dr.end_time
GROUP BY d.id
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Query the name and address of the police station that is responsible for the most roads
SELECT p.p_name, p.address
FROM police_station p
JOIN jurisdiction j ON p.id = j.station_id
GROUP BY p.id
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Query the name and population of the district that has the most traffic violations
SELECT d.d_name, d.population
FROM district d
JOIN violation v ON d.d_name = v.district_name
GROUP BY d.d_name
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Query the name and phone of the car owner who has the most drivers
SELECT c.owner_name, c.owner_phone
FROM car c
JOIN driving d ON c.plate_number = d.plate_number
GROUP BY c.plate_number
ORDER BY COUNT(DISTINCT d.driver_id) DESC
LIMIT 1;

-- Query the name and length of the road that has the lowest traffic level
SELECT r.r_name, r.length
FROM road r
WHERE r.traffic_level = 'low'
ORDER BY r.length ASC
LIMIT 1;

-- Query the name and license type of the driver who drove the most different car models
SELECT d.driver_name, d.license_type
FROM driver d
JOIN driving dr ON d.id = dr.driver_id
JOIN car c ON dr.plate_number = c.plate_number
GROUP BY d.id
ORDER BY COUNT(DISTINCT c.model) DESC
LIMIT 1;

-- Query the name and address of the police station that has the highest average fine amount of the violations under its jurisdiction
SELECT p.p_name, p.address
FROM police_station p
JOIN jurisdiction j ON p.id = j.station_id
JOIN violation v ON j.road_name = v.road_name AND j.district_name = v.district_name
GROUP BY p.id
ORDER BY AVG(v.fine) DESC
LIMIT 1;
