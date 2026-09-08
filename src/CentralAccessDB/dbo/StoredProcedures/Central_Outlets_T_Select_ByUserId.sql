---exec Central_Outlets_T_Select_ByUserId 4165,-2
CREATE PROCEDURE [dbo].[Central_Outlets_T_Select_ByUserId]
	@UserId INT,
	@PropertyId INT=-2
AS
BEGIN
	IF EXISTS(SELECT Username FROM Central_Users WHERE Id=@UserId)
	BEGIN
		SELECT CO.*
		FROM [dbo].[Central_Outlets] CO
		INNER JOIN [dbo].[Central_UserWiseOutlets] AS CUWO ON CO.Id = CUWO.OutletId
		WHERE CUWO.UserId =  @UserId
		AND (@PropertyId = -2 OR CUWO.PropertyId=@PropertyId) 
	END
	ELSE
	BEGIN
		RAISERROR('Invalid User.',16,1)
	END
END

GO

