CREATE PROCEDURE [dbo].[Central_GroupPropertySet_M_Select] 
@Prefix       NVARCHAR(250),
@UserId			INT = 0
AS
BEGIN
	SELECT CP.*
	FROM Central_Properties CP
	INNER JOIN Central_UserWiseProperties UWP ON CP.Id=UWP.PropertyId
	WHERE UWP.UserId=@UserId AND CP.Code=@Prefix
END
--EXEC Central_GroupPropertySet_M_Select 'BNQ',4182

GO

