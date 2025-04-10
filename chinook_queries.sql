--Task 1: List the top 5 customers by total purchase amount.
SELECT c.CustomerId, c.FirstName || ' ' || c.LastName AS CustomerName, SUM(i.Total) AS TotalSpent FROM Invoice i JOIN Customer c ON i.CustomerId = c.CustomerId GROUP BY c.CustomerId ORDER BY TotalSpent DESC LIMIT 5;

-- Task 2: Find the most popular genre in terms of total tracks sold
SELECT g.Name AS Genre, SUM(il.Quantity) AS TotalTracksSold FROM InvoiceLine il JOIN Track t ON il.TrackId = t.TrackId JOIN Genre g ON t.GenreId = g.GenreId GROUP BY g.GenreId ORDER BY TotalTracksSold DESC LIMIT 1;

-- Task 3: Retrieve all employees who are managers along with their subordinates
SELECT m.EmployeeId AS ManagerId, m.FirstName || ' ' || m.LastName AS ManagerName,
       e.EmployeeId AS SubordinateId, e.FirstName || ' ' || e.LastName AS SubordinateName FROM Employee e JOIN Employee m ON e.ReportsTo = m.EmployeeId ORDER BY ManagerId;

-- Task 4: For each artist, find their most sold album
WITH AlbumSales AS (
  SELECT ar.Name AS Artist, al.Title AS Album, al.AlbumId, COUNT(il.InvoiceLineId) AS TotalTracksSold
  FROM InvoiceLine il
  JOIN Track t ON il.TrackId = t.TrackId
  JOIN Album al ON t.AlbumId = al.AlbumId
  JOIN Artist ar ON al.ArtistId = ar.ArtistId
  GROUP BY al.AlbumId
),RankedAlbums AS ( SELECT *, RANK() OVER (PARTITION BY Artist ORDER BY TotalTracksSold DESC) AS rnk
  FROM AlbumSales) SELECT Artist, Album, TotalTracksSold FROM RankedAlbums WHERE rnk = 1;

-- Task 5: Write a query to get monthly sales trends in the year 2013
SELECT strftime('%Y-%m', InvoiceDate) AS Month, SUM(Total) AS MonthlySales FROM Invoice WHERE strftime('%Y', InvoiceDate) = '2013' GROUP BY Month ORDER BY Month;
