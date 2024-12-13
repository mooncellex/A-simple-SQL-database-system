-- Create a database named traffic_violation
CREATE DATABASE traffic_violation;

-- Use the database
USE traffic_violation;

-- Create a table named camera, store the information of the shooting device
CREATE TABLE camera (
  -- Device ID, primary key
  id INT PRIMARY KEY, 
  -- The name of the intersection where the device is located, cannot be empty
  location VARCHAR(50) NOT NULL, 
  -- The status of the device, can only be 'on' or 'off'
  c_status VARCHAR(10) CHECK (c_status IN ('on', 'off')) 
);

-- Create a table named road, store various information of the road
CREATE TABLE road (
  -- Road name
  r_name VARCHAR(50) NOT NULL, 
  -- The name of the district where the road is located
  district_name VARCHAR(50) NOT NULL, 
  -- Road length
  length INT NOT NULL, 
  -- Road speed limit
  speed_limit INT NOT NULL, 
  -- Road traffic condition, can only be 'low', 'medium' or 'high'
  traffic_level VARCHAR(10) CHECK (traffic_level IN ('low', 'medium', 'high')), 
  -- Composite primary key
  PRIMARY KEY (r_name, district_name) 
);

-- Create a table named district, store the information of the district
CREATE TABLE district (
  -- District name, primary key
  d_name VARCHAR(50) PRIMARY KEY,
  -- District population
  population INT NOT NULL, 
  -- District area
  area INT NOT NULL 
);

-- Create a table named police_station, store the information of the police station
CREATE TABLE police_station (
  -- Police station ID, primary key
  id INT PRIMARY KEY, 
  -- Police station name
  p_name VARCHAR(50) NOT NULL, 
  -- Police station address
  address VARCHAR(100) NOT NULL, 
  -- The name of the district where the police station is located, foreign key
  district_name VARCHAR(50) NOT NULL, 
  -- Foreign key constraint, refer to the name column of the district table
  FOREIGN KEY (district_name) REFERENCES district(d_name) 
);

-- Create a table named jurisdiction, store the range of roads under the jurisdiction of the police station
CREATE TABLE jurisdiction (
  -- Police station ID, foreign key
  station_id INT NOT NULL, 
  -- Road name, foreign key
  road_name VARCHAR(50) NOT NULL, 
  -- The name of the district where the road is located, foreign key
  district_name VARCHAR(50) NOT NULL, 
  -- Composite primary key
  PRIMARY KEY (station_id, road_name, district_name), 
  -- Foreign key constraint, refer to the id column of the police_station table
  FOREIGN KEY (station_id) REFERENCES police_station(id), 
  -- Foreign key constraint, refer to the name and district_name columns of the road table
  FOREIGN KEY (road_name, district_name) REFERENCES road(r_name, district_name) 
);

-- Create a table named car, store the information of the car
CREATE TABLE car (
  -- License plate number, primary key
  plate_number VARCHAR(10) PRIMARY KEY, 
  -- Car owner name
  owner_name VARCHAR(50) NOT NULL, 
  -- Car owner phone
  owner_phone VARCHAR(20) NOT NULL, 
  -- Car model
  model VARCHAR(50) NOT NULL, 
  -- Car color
  color VARCHAR(20) NOT NULL 
);

-- Create a table named driver, store the information of the driver
CREATE TABLE driver (
  -- Driver ID, primary key
  id INT PRIMARY KEY, 
  -- Driver name
  driver_name VARCHAR(50) NOT NULL, 
  -- Driver phone
  phone VARCHAR(20) NOT NULL, 
  -- Driver license number
  license_number VARCHAR(20) NOT NULL, 
  -- Driver license type
  license_type VARCHAR(10) CHECK (license_type IN ('A1', 'A2', 'A3', 'B1', 'B2', 'C1', 'C2', 'C3', 'D', 'E', 'F', 'M', 'N', 'P')), 
  -- The URL of the driver's face image
  face_image_url VARCHAR(200) NOT NULL 
);

-- Create a table named driving, store the information of the driver driving the car
CREATE TABLE driving (
  -- Driver ID, foreign key
  driver_id INT NOT NULL, 
  -- License plate number, foreign key
  plate_number VARCHAR(10) NOT NULL, 
  -- Start driving time
  start_time DATETIME NOT NULL, 
  -- End driving time, can be empty
  end_time DATETIME, 
  -- Composite primary key
  PRIMARY KEY (driver_id, plate_number, start_time), 
  -- Foreign key constraint, refer to the id column of the driver table
  FOREIGN KEY (driver_id) REFERENCES driver(id), 
  -- Foreign key constraint, refer to the plate_number column of the car table
  FOREIGN KEY (plate_number) REFERENCES car(plate_number) 
);

-- Create a table named image, store the photo information of the car that ran the red light
CREATE TABLE image (
  -- Photo ID, primary key
  id INT PRIMARY KEY, 
  -- Violation ID, foreign key
  violation_id INT NOT NULL, 
  -- Photo URL
  image_url VARCHAR(200) NOT NULL, 
  -- Photo type, can only be 'car' or 'face'
  i_type VARCHAR(10) CHECK (i_type IN ('car', 'face')) 
);

-- Create a table named violation, store the information of the car that ran the red light
CREATE TABLE violation (
  -- Violation ID, primary key
  id INT PRIMARY KEY, 
  -- License plate number
  plate_number VARCHAR(10) NOT NULL, 
  -- Violation time
  violation_time DATETIME NOT NULL, 
  -- Shooting device ID, foreign key
  camera_id INT NOT NULL, 
  -- The name of the road where the violation occurred, foreign key
  road_name VARCHAR(50) NOT NULL, 
  -- The name of the district where the violation occurred, foreign key
  district_name VARCHAR(50) NOT NULL, 
  -- Violation fine
  fine INT NOT NULL, 
  -- The ID of the driver's face image taken when running the red light, foreign key
  face_image_id INT NOT NULL, 
  -- Foreign key constraint, refer to the id column of the camera table
  FOREIGN KEY (camera_id) REFERENCES camera(id), 
  -- Foreign key constraint, refer to the name and district_name columns of the road table
  FOREIGN KEY (road_name, district_name) REFERENCES road(r_name, district_name), 
  -- Foreign key constraint, refer to the id column of the image table
  FOREIGN KEY (face_image_id) REFERENCES image(id) 
);

-- Insert some sample data into each table 

-- Insert some sample data into the camera table
INSERT INTO camera (id, location, c_status) VALUES
(1, 'Central', 'on'),
(2, 'Causeway Bay', 'on'),
(3, 'Mong Kok', 'off'),
(4, 'Sha Tin', 'on'),
(5, 'Tsim Sha Tsui', 'on'),
(6, 'Tsuen Wan', 'off'),
(7, 'Yuen Long', 'on'),
(8, 'Kwun Tong', 'on'),
(9, 'Wan Chai', 'on'),
(10, 'Tai Po', 'off');

-- Insert some sample data into the road table
INSERT INTO road (r_name, district_name, length, speed_limit, traffic_level) VALUES
('Des Voeux Road Central', 'Central and Western District', 500, 50, 'high'),
('Causeway Bay Road', 'Wan Chai District', 800, 60, 'medium'),
('Sha Tin Wai Road', 'Sha Tin District', 1000, 80, 'low'),
('Lockhart Road', 'Wan Chai District', 600, 50, 'high'),
('Nathan Road', 'Yau Tsim Mong District', 1200, 60, 'high'),
('Castle Peak Road', 'Tsuen Wan District', 1500, 80, 'medium'),
('Yuen Long Main Road', 'Yuen Long District', 800, 60, 'low'),
('Kwun Tong Road', 'Kwun Tong District', 1000, 70, 'medium'),
('Hennessy Road', 'Wan Chai District', 700, 50, 'high'),
('Tai Po Road', 'Tai Po District', 1200, 80, 'low');

-- Insert some sample data into the district table
INSERT INTO district (d_name, population, area) VALUES
('Central and Western District', 250000, 12),
('Wan Chai District', 180000, 10),
('Sha Tin District', 650000, 68),
('Yau Tsim Mong District', 340000, 9),
('Tsuen Wan District', 310000, 61),
('Yuen Long District', 610000, 138),
('Kwun Tong District', 650000, 11),
('Tai Po District', 310000, 136);

-- Insert some sample data into the police_station table
INSERT INTO police_station (id, p_name, address, district_name) VALUES
(1, 'Central Police Station', '2 Queens Road Central, Central', 'Central and Western District'),
(2, 'Causeway Bay Police Station', '280 Gloucester Road, Causeway Bay', 'Wan Chai District'),
(3, 'Sha Tin Police Station', '1 Yuen Wo Road, Sha Tin', 'Sha Tin District'),
(4, 'Wan Chai Police Station', '1 Harbour Road, Wan Chai', 'Wan Chai District'),
(5, 'Tsim Sha Tsui Police Station', '1 Salisbury Road, Tsim Sha Tsui', 'Yau Tsim Mong District'),
(6, 'Tsuen Wan Police Station', '18 Sai Lau Kok Road, Tsuen Wan', 'Tsuen Wan District'),
(7, 'Yuen Long Police Station', '2 Kiu Lok Square, Yuen Long', 'Yuen Long District'),
(8, 'Kwun Tong Police Station', '2 Shing Yip Street, Kwun Tong', 'Kwun Tong District'),
(9, 'Central District Police Station', '11 Hing Wan Street, Central', 'Central and Western District'),
(10, 'Tai Po Police Station', '11 On Po Lane, Tai Po', 'Tai Po District');

-- Insert some sample data into the jurisdiction table
INSERT INTO jurisdiction (station_id, road_name, district_name) VALUES
(1, 'Des Voeux Road Central', 'Central and Western District'),
(2, 'Causeway Bay Road', 'Wan Chai District'),
(3, 'Sha Tin Wai Road', 'Sha Tin District'),
(2, 'Lockhart Road', 'Wan Chai District'),
(4, 'Lockhart Road', 'Wan Chai District'),
(5, 'Nathan Road', 'Yau Tsim Mong District'),
(6, 'Castle Peak Road', 'Tsuen Wan District'),
(7, 'Yuen Long Main Road', 'Yuen Long District'),
(8, 'Kwun Tong Road', 'Kwun Tong District'),
(9, 'Hennessy Road', 'Wan Chai District'),
(4, 'Hennessy Road', 'Wan Chai District'),
(10, 'Tai Po Road', 'Tai Po District');

-- Insert some sample data into the car table
INSERT INTO car (plate_number, owner_name, owner_phone, model, color) VALUES
('粤A12345', 'Li Ming', '13800138000', 'Audi A6', 'black'),
('粤B67890', 'Wang Hua', '13900990099', 'BMW X5', 'white'),
('港C13579', 'Chen Jia', '85212345678', 'Tesla S', 'red'),
('港D24680', 'Lin Zhi', '85287654321', 'Honda CR-V', 'silver'),
('粤E35791', 'Zhang Lei', '13700990088', 'Toyota Camry', 'blue'),
('港F46802', 'Wong Siu', '85223456789', 'Nissan Qashqai', 'gray'),
('粤G57913', 'Liu Wei', '13600880077', 'Ford Focus', 'green'),
('港H68024', 'Chan Kwok', '85234567890', 'Hyundai Sonata', 'gold'),
('粤J80246', 'Zhao Jun', '13500770066', 'Volkswagen Jetta', 'brown'),
('港K91357', 'Lee Wing', '85245678901', 'Mazda 3', 'yellow');


-- Insert some sample data into the driver table
INSERT INTO driver (id, driver_name, phone, license_number, license_type, face_image_url) VALUES
(1, 'Li Ming', '13800138000', '440101199001011234', 'C1', 'https://i.imgur.com/11.jpg'),
(2, 'Wang Hua', '13900990099', '440102199002022345', 'C2', 'https://i.imgur.com/12.jpg'),
(3, 'Chen Jia', '85212345678', 'HK1234567890', 'B2', 'https://i.imgur.com/13.jpg'),
(4, 'Lin Zhi', '85287654321', 'HK0987654321', 'B1', 'https://i.imgur.com/14.jpg'),
(5, 'Zhang Lei', '13700990088', '440103199003033456', 'C1', 'https://i.imgur.com/15.jpg'),
(6, 'Wong Siu', '85223456789', 'HK2345678901', 'B2', 'https://i.imgur.com/16.jpg'),
(7, 'Liu Wei', '13600880077', '440104199004044567', 'C2', 'https://i.imgur.com/17.jpg'),
(8, 'Chan Kwok', '85234567890', 'HK3456789012', 'B1', 'https://i.imgur.com/18.jpg'),
(9, 'Zhao Jun', '13500770066', '440105199005055678', 'C1', 'https://i.imgur.com/19.jpg'),
(10, 'Lee Wing', '85245678901', 'HK4567890123', 'B2', 'https://i.imgur.com/20.jpg');

-- Insert some sample data into the driving table
INSERT INTO driving (driver_id, plate_number, start_time, end_time) VALUES
(1, '粤A12345', '2023-11-24 00:00:00', '2023-11-24 01:00:00'),
(2, '粤B67890', '2023-11-24 00:05:00', '2023-11-24 00:55:00'),
(3, '港C13579', '2023-11-24 00:10:00', '2023-11-24 00:50:00'),
(4, '港D24680', '2023-11-24 00:15:00', '2023-11-24 00:45:00'),
(5, '粤E35791', '2023-11-24 00:20:00', '2023-11-24 00:40:00'),
(6, '港F46802', '2023-11-24 00:25:00', '2023-11-24 00:35:00'),
(7, '粤G57913', '2023-11-24 00:30:00', '2023-11-24 00:30:00'),
(8, '港H68024', '2023-11-24 00:35:00', NULL),
(9, '粤J80246', '2023-11-24 00:40:00', NULL),
(10, '港K91357', '2023-11-24 00:45:00', NULL);

-- Insert some sample data into the image table
INSERT INTO image (id, violation_id, image_url, i_type) VALUES
(1, 1, 'https://i.imgur.com/21.jpg', 'face'),
(2, 2, 'https://i.imgur.com/22.jpg', 'face'),
(3, 3, 'https://i.imgur.com/23.jpg', 'face'),
(4, 4, 'https://i.imgur.com/24.jpg', 'face'),
(5, 5, 'https://i.imgur.com/25.jpg', 'face'),
(6, 6, 'https://i.imgur.com/26.jpg', 'face'),
(7, 7, 'https://i.imgur.com/27.jpg', 'face'),
(8, 8, 'https://i.imgur.com/28.jpg', 'face'),
(9, 9, 'https://i.imgur.com/29.jpg', 'face'),
(10, 10, 'https://i.imgur.com/30.jpg', 'face'),
(11, 1, 'https://i.imgur.com/31.jpg', 'car'),
(12, 2, 'https://i.imgur.com/32.jpg', 'car'),
(13, 3, 'https://i.imgur.com/33.jpg', 'car'),
(14, 4, 'https://i.imgur.com/34.jpg', 'car'),
(15, 5, 'https://i.imgur.com/35.jpg', 'car'),
(16, 6, 'https://i.imgur.com/36.jpg', 'car'),
(17, 7, 'https://i.imgur.com/37.jpg', 'car'),
(18, 8, 'https://i.imgur.com/38.jpg', 'car'),
(19, 9, 'https://i.imgur.com/39.jpg', 'car'),
(20, 10, 'https://i.imgur.com/40.jpg', 'car');

-- Insert some sample data into the violation table
INSERT INTO violation (id, plate_number, violation_time, camera_id, road_name, district_name, fine, face_image_id) VALUES
(1, '粤A12345', '2023-11-24 00:10:23', 1, 'Des Voeux Road Central', 'Central and Western District', 500, 1),
(2, '粤B67890', '2023-11-24 00:12:34', 2, 'Causeway Bay Road', 'Wan Chai District', 600, 2),
(3, '港C13579', '2023-11-24 00:15:45', 4, 'Sha Tin Wai Road', 'Sha Tin District', 400, 3),
(4, '港D24680', '2023-11-24 00:18:56', 2, 'Lockhart Road', 'Wan Chai District', 500, 4),
(5, '粤E35791', '2023-11-24 00:21:07', 5, 'Nathan Road', 'Yau Tsim Mong District', 500, 5),
(6, '港F46802', '2023-11-24 00:23:18', 6, 'Castle Peak Road', 'Tsuen Wan District', 400, 6),
(7, '粤G57913', '2023-11-24 00:25:29', 7, 'Yuen Long Main Road', 'Yuen Long District', 400, 7),
(8, '港H68024', '2023-11-24 00:27:40', 8, 'Kwun Tong Road', 'Kwun Tong District', 500, 8),
(9, '粤J80246', '2023-11-24 00:29:51', 9, 'Hennessy Road', 'Wan Chai District', 600, 9),
(10, '港K91357', '2023-11-24 00:32:02', 10, 'Tai Po Road', 'Tai Po District', 400, 10);









