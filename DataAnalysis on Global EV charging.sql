USE global_ev_charging_behaviour;
DROP TABLE ev_data;

CREATE TABLE ev_data (
    Country VARCHAR(100),
    City VARCHAR(100),
    Charging_Station_ID VARCHAR(150),
    Charging_Station_Type VARCHAR(100),
    EV_Model VARCHAR(100),
    Manufacturer VARCHAR(100),
    Battery_Capacity_kWh INT,
    Charging_Start_Time DATETIME,
    Charging_End_Time DATETIME,
    Charging_Duration_mins INT, 
    Energy_Delivered_kWh DECIMAL(10,2), 
    Charging_Cost DECIMAL(10,2), 
    Payment_Method VARCHAR(100),
    Temperature DECIMAL(5,2),
    Charging_Session_Outcome VARCHAR(100),
    Station_Utilization_Rate DECIMAL(5,2)
);
SELECT * FROM ev_data;

-- How many total charging sessions are recorded in the dataset?
SELECT COUNT(*) AS total_sessions
FROM ev_data;

-- Number of charging sessions per country?
SELECT Country, COUNT(Charging_Session_Outcome) AS Number_of_Charging_Sessions
FROM ev_data
GROUP BY Country
ORDER BY Number_of_Charging_Sessions DESC;

-- Find all charging stations that use ‘Credit Card’ or ‘Mobile Payment’ as the payment method.
SELECT Payment_Method, COUNT(DISTINCT(Charging_Station_ID)) AS Number_of_Charging_Stations
FROM ev_data
WHERE Payment_Method IN ('Subscription', 'Card', 'App') 
GROUP BY Payment_Method;

-- All EV models from Tesla or Nissan that failed to complete the session.
SELECT EV_Model, Manufacturer , Charging_Session_Outcome
FROM ev_data
WHERE Manufacturer IN ('Tesla', 'Nissan')
    AND Charging_Session_outcome = 'Failed';

-- Charging cost per kWh for each session
SELECT Charging_Cost/Energy_Delivered_kWh AS cost_per_kwh
FROM ev_data
WHERE Energy_Delivered_kWh > 0;

-- Summarize total energy delivered, average charging cost, and max charging duration for each charging station type.
SELECT Charging_Station_Type, SUM(Energy_Delivered_kWh) As total_energy_delivered,
       AVG(Charging_Cost) As avg_charging_cost,
       MAX(Charging_Duration_mins) AS max_charging_duration
FROM ev_data
GROUP BY Charging_Station_Type;

-- List of all distinct EV models available in Germany.
SELECT DISTINCT EV_Model AS unique_EV_Models
FROM ev_data
WHERE Country = 'Germany';

-- Top 10 Cities which has the highest number of aborted sessions?
SELECT Country, City, COUNT(Charging_Session_Outcome) AS aborted_sessions
FROM ev_data
WHERE Charging_Session_Outcome = 'Aborted'
GROUP BY City, Country
ORDER BY aborted_sessions DESC
LIMIT 10;

-- EV models which had more than 25 completed sessions?
SELECT EV_Model, Count(Charging_Session_Outcome) AS completed_sessions
FROM ev_data
WHERE Charging_Session_Outcome = 'Completed'
GROUP BY EV_Model
HAVING count(*) > 25;

-- 3 EV models which had the longest average charging duration?
SELECT EV_Model, AVG(Charging_Duration_mins) As avg_charging_duration
FROM ev_data
GROUP BY EV_Model
ORDER BY avg_charging_duration DESC
LIMIT 3;

-- Top 5 EV Models with highest average battery Capacity
SELECT EV_Model, AVG(Battery_Capacity_kWh) AS avg_battery_capacity
FROM ev_data
GROUP BY EV_Model
Order by avg_battery_capacity DESC
LIMIT 5;

-- EV Charging Session Count by Country for Selected Models (Porsche Taycan & Audi e-tron)
SELECT DISTINCT EV_Model, Country, COUNT(Charging_Session_Outcome) AS total_sessions
From ev_data
WHERE EV_Model IN ('Audi e-tron', 'Porsche Taycan')
GROUP BY Country, EV_Model
ORDER BY total_sessions DESC;








