CREATE PROCEDURE [dbo].[Report_UserWiseGrantedProperties_Select]
	@UserId INT
AS
BEGIN
	SELECT DISTINCT A.PropertyId,
	(SELECT Name FROM Central_Properties WHERE Id=A.PropertyId) AS PropertyName
	FROM Central_UserWiseProperties A
	WHERE A.UserId=@UserId
END

GO

