----// 1.�����
visitorID INT PRIMARY KEY IDENTITY(1,1),
firstname NVARCHAR(50) NOT NULL,
lastname NVARCHAR(50) NOT NULL,
passport INT NOT NULL
);

CREATE TABLE Rooms (
roomsID INT PRIMARY KEY IDENTITY(1,1),
size INT NOT NULL,
stars INT NOT NULL,
name NVARCHAR(50) NOT NULL 
);


CREATE TABLE Position(
positionID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
positionName NVARCHAR(50) NOT NULL,
salary INT NOT NULL,
rate INT NOT NULL
);

CREATE TABLE Employee (
employeeID INT PRIMARY KEY IDENTITY(1,1),
firstname NVARCHAR(50) NOT NULL,
lastname NVARCHAR(50) NOT NULL,
position INT NOT NULL
FOREIGN KEY (position) REFERENCES Position(positionID)
);

CREATE TABLE Journal (
journalID INT NOT NULL PRIMARY KEY IDENTITY (1,1),
visitorID INT NULL,
roomID INT NOT NULL,
EmployeeID INT NOT NULL,
checkIn DATETIME NOT NULL,
checkOut DATETIME NOT NULL
CONSTRAINT FK_Journal_Visitor_visitorID FOREIGN KEY (visitorID) REFERENCES Visitors(visitorID) ON DELETE SET NULL,
CONSTRAINT FK_Journal_Rooms_roomID FOREIGN KEY (roomID) REFERENCES Rooms(roomsID),
CONSTRAINT FK_Journal_Employee_employeeID FOREIGN KEY (employeeID) REFERENCES Employee(employeeID)
);

ALTER TABLE Visitors DROP COLUMN passport 
ALTER TABLE Visitors ADD passport VARCHAR(20) NOT NULL;


INSERT INTO Visitors (firstname,lastname, passport) VALUES ('Paula','Gonzales','65669');

CREATE PROCEDURE sp_RemoveVisitor
AS
BEGIN

DELETE Visitors 
WHERE visitorID IN 
		(SELECT DISTINCT visitorID 
		FROM Journal 
		WHERE checkOut < GETDATE())

END;

CREATE FUNCTION GetFreeRoom(@stars INT, @date DATETIME)
RETURNS INT
AS
BEGIN
DECLARE @roomCount INT

 SELECT @roomCount = COUNT(*) 
 FROM Rooms  
 WHERE  Rooms.roomsID NOT IN (SELECT roomsID 
		FROM Journal 
		WHERE @date BETWEEN checkIn AND checkOut)
 AND Rooms.stars = @stars
 RETURN @roomCount

END;

INSERT INTO Rooms VALUES (230,3,'lux');

INSERT INTO Rooms VALUES (2,1,'poorPeople');
INSERT INTO Rooms VALUES (1500,3,'business');
INSERT INTO Rooms VALUES (23,2,'DveStars');
INSERT INTO Rooms VALUES (10000,3,'DonaldTrump');
INSERT INTO Rooms VALUES (20,3,'NotLux');

INSERT INTO Employee VALUES ('Fletcher','Howe',3);

INSERT INTO Journal VALUES (2, 1, 1, GETDATE(), DATEADD(DAY, 1, GETDATE()))
INSERT INTO Journal VALUES (2, 1, 1, GETDATE(), DATEADD(DAY, -7, GETDATE()))


	
SELECT	dbo.GetFreeRoom(3, DATEADD(DAY, 3, GETDATE()));

EXEC sp_RemoveVisitor
