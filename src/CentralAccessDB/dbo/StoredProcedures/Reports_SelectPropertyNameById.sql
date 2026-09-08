CREATE PROCEDURE [dbo].[Reports_SelectPropertyNameById]
@PropertyId INT
AS
BEGIN
	SELECT Name FROM Central_Properties WHERE Id=@PropertyId
END

GO

