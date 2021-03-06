--1. non_usa_customers.sql: Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT FirstName, 
	LastName, 
	CustomerId, 
	Country 
FROM Customer 
WHERE Country != 'USA';

--2. brazil_customers.sql: Provide a query only showing the Customers from Brazil.
SELECT FirstName, 
	LastName, 
	CustomerId, 
	Country 
FROM Customer 
WHERE Country ='Brazil';

--3. brazil_customers_invoices.sql: Provide a query showing the Invoices of customers who are from Brazil. 
--The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS 'Full Name',
	i.InvoiceId,
	i.InvoiceDate,
	i.BillingCountry
FROM Customer c
LEFT JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE c.Country = 'Brazil';

--4. sales_agents.sql: Provide a query showing only the Employees who are Sales Agents.
SELECT CONCAT(FirstName, ' ', LastName) AS 'Employee Name',
	Title
FROM Employee
WHERE Title ='Sales Support Agent';

--5. unique_invoice_countries.sql: Provide a query showing a unique/distinct list of billing countries from the Invoice table.
SELECT DISTINCT BillingCountry 
FROM Invoice;

--6. sales_agent_invoices.sql: Provide a query that shows the invoices associated with each sales agent. 
--The resultant table should include the Sales Agent's full name.
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS 'Agent Name',
	i.InvoiceId,
	i.BillingAddress,
	i.BillingCity,
	i.BillingCountry,
	i.BillingPostalCode,
	i.Total
FROM Customer c
LEFT JOIN Employee e ON e.EmployeeId = c.SupportRepId
LEFT JOIN Invoice i ON i.CustomerId = c.CustomerId; 
--if an employee's Id matches a customer's support rep Id then they are a sales rep; this filters the results to include only sales agents

--7. invoice_totals.sql: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT i.Total AS 'Invoice Total',
	CONCAT(c.FirstName, ' ', c.LastName) AS 'Customer Name',
	i.BillingCountry,
	CONCAT(e.FirstName, ' ', e.LastName) AS 'Agent Name'
FROM Customer c
LEFT JOIN Employee e ON e.EmployeeId = c.SupportRepId
LEFT JOIN Invoice i ON i.CustomerId = c.CustomerId;

--8. total_invoices_{year}.sql: How many Invoices were there in 2009 and 2011?
--SUBSTRING extracts some characters from a string; doing this to extract only the year from InvoiceDate
--SUBSTRING(string, start, length)
--Since InvoiceDate is type datetime, must convert to string 
--111 is the formatting style number for yyyy
--0, 5 here will get the first 4 digits; i.e. the only thing we need for the yyyy format
SELECT SUBSTRING(CONVERT(VARCHAR, InvoiceDate, 111), 0, 5) AS 'Year',
COUNT(InvoiceId) AS 'Number of invoices'
FROM Invoice
WHERE InvoiceDate LIKE '%2009%' OR InvoiceDate LIKE '%2011%'
--GROUP BY is needed to group the result set by year
GROUP BY SUBSTRING(CONVERT(VARCHAR, InvoiceDate, 111), 0, 5);

--9. total_sales_{year}.sql: What are the respective total sales for each of those years?
SELECT SUBSTRING(CONVERT(VARCHAR, InvoiceDate, 111), 0, 5) AS 'Year',
SUM(Total) AS 'Total Sales'
FROM Invoice
WHERE InvoiceDate LIKE '%2009%' OR InvoiceDate LIKE '%2011%'
GROUP BY SUBSTRING(CONVERT(VARCHAR, InvoiceDate, 111), 0, 5);

--10. invoice_37_line_item_count.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT COUNT(InvoiceLineId) AS 'Number of Line Items'
FROM InvoiceLine
WHERE InvoiceId = 37;

--11. line_items_per_invoice.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
SELECT COUNT(InvoiceLineId) AS 'Number of Line Items',
	InvoiceId
FROM InvoiceLine
GROUP BY InvoiceId;

--12. line_item_track.sql: Provide a query that includes the purchased track name with each invoice line item.
SELECT 	il.InvoiceId,
	il.InvoiceLineId,
	t.Name AS 'Track Name'
FROM Track t
--LEFT JOIN includes tracks with null invoice values
--(INNER) JOIN only returns matching values
JOIN InvoiceLine il ON t.TrackId = il.TrackId;

--13. line_item_track_artist.sql: Provide a query that includes the purchased track name AND artist name with each invoice line item.
SELECT il.InvoiceId,
	il.InvoiceLineId,
	t.Name AS 'Track Name',
	ar.Name AS 'Artist Name'
FROM Track t
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Album al ON al.AlbumId = t.AlbumId
JOIN Artist ar ON ar.ArtistId = al.AlbumId;

--14. country_invoices.sql: Provide a query that shows the # of invoices per country. HINT: GROUP BY
SELECT COUNT(InvoiceId) AS 'Number of Invoices',
	BillingCountry AS 'Country'
FROM Invoice
GROUP BY BillingCountry;

--15. playlists_track_count.sql: Provide a query that shows the total number of tracks in each playlist. 
--The Playlist name should be include on the resulant table.
SELECT p.Name AS 'Playlist Name',
	COUNT(pt.TrackId) AS 'Number of Tracks'
FROM Playlist p
JOIN PlaylistTrack pt ON pt.PlaylistId = p.PlaylistId
GROUP BY p.Name;

--16. tracks_no_id.sql: Provide a query that shows all the Tracks, but displays no IDs. 
--The result should include the Album name, Media type and Genre.
SELECT t.Name AS 'Track Name',
	a.Title AS 'Album Name',
	mt.Name AS 'Media Type',
	g.Name AS 'Genre'
FROM Track t, Album a, MediaType mt, Genre g
WHERE a.AlbumId = t.AlbumId
AND t.MediaTypeId = mt.MediaTypeId
AND t.GenreId = g.GenreId;
--JOINs would work the same here, but this looks neater

--17. invoices_line_item_count.sql: Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT i.InvoiceId AS 'Invoice Id',
	COUNT(il.InvoiceLineId) AS 'Number of line items'
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY i.InvoiceId;

--18. sales_agent_total_sales.sql: Provide a query that shows total sales made by each sales agent.
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS 'Sales Agent',
	SUM(i.Total) AS 'Total Sales'
FROM Employee e, Invoice i, Customer c
WHERE c.SupportRepId = e.EmployeeId
AND i.CustomerId = c.CustomerId
GROUP BY CONCAT(e.FirstName, ' ', e.LastName);

--19. top_2009_agent.sql: Which sales agent made the most in sales in 2009?
--order by descending totals, select only the first row
--tried using LIMIT 1 at first, but doesn't seem to be supported by SSMS
--same substring logic from earlier query
SELECT TOP 1
	CONCAT(e.FirstName, ' ', e.LastName) AS 'Sales Agent',
	SUM(i.Total) AS 'Total Sales in 2009'
FROM Employee e, Invoice i, Customer c
WHERE c.SupportRepId = e.EmployeeId
AND i.CustomerId = c.CustomerId
AND SUBSTRING(CONVERT(VARCHAR(10), i.InvoiceDate, 111), 0, 5) LIKE '%2009%'
GROUP BY CONCAT(e.FirstName, ' ', e.LastName)
ORDER BY SUM(i.Total) DESC;

--20. top_agent.sql: Which sales agent made the most in sales over all?
SELECT TOP 1
	CONCAT(e.FirstName, ' ', e.LastName) AS 'Sales Agent',
	SUM(i.Total) AS 'Total Overall Sales'
FROM Employee e, Invoice i, Customer c
WHERE c.SupportRepId = e.EmployeeId
AND i.CustomerId = c.CustomerId
GROUP BY CONCAT(e.FirstName, ' ', e.LastName)
ORDER BY SUM(i.Total) DESC;

--21. sales_agent_customer_count.sql: Provide a query that shows the count of customers assigned to each sales agent.
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS 'Sales Agent',
	COUNT(c.CustomerId) AS 'Number of Customers'
FROM Employee e, Customer c
WHERE c.SupportRepId = e.EmployeeId
GROUP BY CONCAT(e.FirstName, ' ', e.LastName);

--22. sales_per_country.sql: Provide a query that shows the total sales per country.
SELECT BillingCountry AS 'Country',
	SUM(Total) AS 'Total Sales'
FROM Invoice
GROUP BY BillingCountry;

--23. top_country.sql: Which country's customers spent the most?
SELECT TOP 1
	BillingCountry AS 'Country with Top Sales',
	SUM(Total) AS 'Total Sales'
FROM Invoice
GROUP BY BillingCountry
ORDER BY SUM(Total) DESC;

--24. top_2013_track.sql: Provide a query that shows the most purchased track of 2013.
--Join track id, invoice line, and invoice where year on invoice date is 2013
--Without the joins, the number purchased is much higher
SELECT TOP 1
	t.NAME AS 'Track Name',
	COUNT(il.TrackId) AS 'Number Purchased'
FROM Track t
JOIN InvoiceLine il ON il.TrackId = t.TrackId
JOIN Invoice i ON i.InvoiceId = il.InvoiceId
--alternate way to find 2013 from the substring conversion in previous queries
WHERE i.InvoiceDate BETWEEN '2013-01-01' and '2013-12-31'
GROUP BY t.Name
ORDER BY COUNT(il.TrackId) DESC;

--25. top_5_tracks.sql: Provide a query that shows the top 5 most purchased songs.
SELECT TOP 5
	t.Name AS 'Track Name',
	COUNT(il.TrackId) AS 'Number Purchased'
FROM Track t
JOIN InvoiceLine il ON il.TrackId = t.TrackId
JOIN Invoice i ON i.InvoiceId = il.InvoiceId
GROUP BY t.Name
ORDER BY COUNT(il.TrackId) DESC;

--26. top_3_artists.sql: Provide a query that shows the top 3 best selling artists.
SELECT TOP 3
	ar.Name,
	COUNT(il.TrackId) AS 'Tracks Sold'
FROM Artist ar
JOIN Album al ON al.ArtistId = ar.ArtistId
JOIN Track t ON t.AlbumId = al.AlbumId
JOIN InvoiceLine il ON il.TrackId = t.TrackId
JOIN Invoice i ON i.InvoiceId = il.InvoiceId
GROUP BY ar.Name
ORDER BY COUNT(il.TrackId) DESC;

--27. top_media_type.sql: Provide a query that shows the most purchased Media Type.
SELECT TOP 1
	mt.Name AS 'Media Type',
	COUNT(il.TrackId) AS 'Number of Tracks Sold'
FROM MediaType mt
JOIN Track t ON mt.MediaTypeId = t.MediaTypeId
JOIN InvoiceLine il ON il.TrackId = t.TrackId
GROUP BY mt.Name
ORDER BY COUNT(il.TrackId) DESC;
