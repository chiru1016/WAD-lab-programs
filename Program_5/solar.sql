-- Create table Solar_Panel to store details of solar PV modules such as type, capacity, price and warranty.
CREATE TABLE Solar_Panel (
    PV_Module VARCHAR(6) PRIMARY KEY,
    PV_Type VARCHAR(20),
    Capacity INT,
    Price INT,
    Warranty_Type INT
);

-- Create table Vendor to store distributor details like TIN, name, address and contact information.
CREATE TABLE Vendor (
    TIN INT(6) PRIMARY KEY,
    Name VARCHAR(20),
    Address VARCHAR(20),
    Contact VARCHAR(30)
);

-- Create table Users to store customer/building details including building number, name and area.
CREATE TABLE Users (
    Building_No INT(4) PRIMARY KEY,
    Name VARCHAR(20),
    Area VARCHAR(30)
);

-- Create table SOLD_BY to represent the relationship between Vendor and Solar_Panel (which vendor sells which panel).
CREATE TABLE SOLD_BY (
    TIN INT(6),
    PV_Module VARCHAR(6),
    PRIMARY KEY (TIN, PV_Module),
    FOREIGN KEY (TIN) REFERENCES Vendor(TIN),
    FOREIGN KEY (PV_Module) REFERENCES Solar_Panel(PV_Module)
);

-- Create table PURCHASED_BY to represent which user/building purchased which solar panel.
CREATE TABLE PURCHASED_BY (
    PV_Module VARCHAR(6),
    Building_No INT(4),
    PRIMARY KEY (PV_Module, Building_No),
    FOREIGN KEY (PV_Module) REFERENCES Solar_Panel(PV_Module),
    FOREIGN KEY (Building_No) REFERENCES Users(Building_No)
);

-- Create table INSTALLED_BY to store installation details including vendor, building, date, charges and installation type.
CREATE TABLE INSTALLED_BY (
    PV_Module VARCHAR(6),
    TIN INT(6),
    Building_No INT(4),
    Installation_Date DATE,
    Installation_Charges INT,
    Type VARCHAR(20),
    PRIMARY KEY (PV_Module, TIN, Building_No),
    FOREIGN KEY (PV_Module) REFERENCES Solar_Panel(PV_Module),
    FOREIGN KEY (TIN) REFERENCES Vendor(TIN),
    FOREIGN KEY (Building_No) REFERENCES Users(Building_No)
);


-- Insert sample records into Solar_Panel table.
INSERT INTO Solar_Panel VALUES
('PV001', 'Monocrystalline', 3, 70000, 15),
('PV002', 'Polycrystalline', 5, 90000, 25),
('PV003', 'Monocrystalline', 4, 75000, 15),
('PV004', 'Polycrystalline', 6, 95000, 25),
('PV005', 'Monocrystalline', 2, 60000, 15);

-- Insert sample distributor records into Vendor table.
INSERT INTO Vendor VALUES
(100101, 'SunPower', 'Chennai', '9876543210'),
(100102, 'GreenVolt', 'Bangalore', '9123456780'),
(100103, 'SolarTech', 'Hyderabad', '9988776655');

-- Insert sample customer/building records into Users table.
INSERT INTO Users VALUES
(101, 'Ravi Kumar', 'T Nagar'),
(102, 'Anita Sharma', 'Anna Nagar'),
(201, 'ABC Hotel', 'T Nagar'),
(202, 'XYZ Office', 'Bangalore Central');

-- Insert relationship data into SOLD_BY table.
INSERT INTO SOLD_BY VALUES
(100101, 'PV001'),
(100101, 'PV002'),
(100102, 'PV003'),
(100103, 'PV004'),
(100102, 'PV005');

-- Insert relationship data into PURCHASED_BY table.
INSERT INTO PURCHASED_BY VALUES
('PV001', 101),
('PV002', 201),
('PV003', 102),
('PV004', 202),
('PV005', 201);

-- Insert installation details into INSTALLED_BY table.
INSERT INTO INSTALLED_BY VALUES
('PV001', 100101, 101, '2018-06-15', 40000, 'Domestic'),
('PV002', 100101, 201, '2017-03-10', 60000, 'Commercial'),
('PV003', 100102, 102, '2019-08-20', 40000, 'Domestic'),
('PV004', 100103, 202, '2016-01-05', 60000, 'Commercial'),
('PV005', 100102, 201, '2020-11-12', 40000, 'Commercial');



/* ============================================================
   QUERY 1
List the distributor with most installations in domestic places

Expected Output:
Name Installation Type
Value-1 Value-1
Value-2 Value-2
======================================================= */
SELECT
    v.Name,
    i.Type,
    COUNT(i.TIN) AS Installation_Count
FROM
    Vendor v,
    INSTALLED_BY i
WHERE
    v.TIN = i.TIN
    AND i.Type = 'Domestic'
GROUP BY
    v.TIN,
    v.Name,
    i.Type
HAVING COUNT(i.TIN) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(TIN) AS cnt
        FROM INSTALLED_BY
        WHERE Type = 'Domestic'
        GROUP BY TIN
    ) AS temp
);


/* ============================================================
   QUERY 2
List the place name with highest capacity panel installed

Expected Output:
Name max(s.capacity)
Value-1 Value-1
Value-2 Value-2
============================================================ */
SELECT
    u.Area,
    p.Capacity
FROM
    Users u,
    Solar_Panel p,
    INSTALLED_BY i
WHERE
    u.Building_No = i.Building_No
    AND p.PV_Module = i.PV_Module
    AND p.Capacity = (
        SELECT MAX(Capacity)
        FROM Solar_Panel
    );


/* ============================================================
   QUERY 3
Display the area where monocrystalline panels are installed

Expected Output:
Area Pv_type
Value-1 Value-1
Value-2 Value-2
======================================================== */
SELECT DISTINCT
    u.Area,
    p.PV_Type
FROM
    Users u,
    Solar_Panel p,
    INSTALLED_BY i
WHERE
    u.Building_No = i.Building_No
    AND p.PV_Module = i.PV_Module
    AND p.PV_Type = 'Monocrystalline';


/* ============================================================
   QUERY 4
For the specific area display the total installation charges for both type of PV Modules

Expected Output:
sum(i.install_charges) Area
Value-1 Value-1
Value-1 Value-1
============================================================ */
SELECT
    SUM(i.Installation_Charges) AS Total_Charges,
    u.Area,
    p.PV_Type
FROM
    Users u,
    INSTALLED_BY i,
    Solar_Panel p
WHERE
    u.Building_No = i.Building_No
    AND i.PV_Module = p.PV_Module
    AND u.Area = 'T Nagar'
GROUP BY
    u.Area,
    p.PV_Type;


/* ============================================================
   QUERY 5
List the details of distributors and panel that is the oldest installation

Expected Output:
Name pv_module price pv_type capacity installion_date
Value-1 Value-1 Value-1 Value-1 Value-1 Value-1
Value-1 Value-1 Value-1 Value-1 Value-1 Value-1
============================================================ */
SELECT
    v.Name,
    p.PV_Module,
    p.PV_Type,
    p.Price,
    p.Capacity,
    i.Installation_Date
FROM
    Vendor v,
    INSTALLED_BY i,
    Solar_Panel p
WHERE
    v.TIN = i.TIN
    AND p.PV_Module = i.PV_Module
    AND i.Installation_Date = (
        SELECT MIN(Installation_Date)
        FROM INSTALLED_BY
    );


/* ============================================================
   QUERY 6
Find the average sales of both type of panels in only commercial places

Expected Output:
Installation Type Average installation charge
Value-1 Value-1
Value-1 Value-1
=========================================================
SELECT
    p.PV_Type,
    AVG(i.Installation_Charges) AS Average_Installation_Charge
FROM
    Solar_Panel p,
    INSTALLED_BY i
WHERE
    p.PV_Module = i.PV_Module
    AND i.Type = 'Commercial'
GROUP BY
    p.PV_Type;
