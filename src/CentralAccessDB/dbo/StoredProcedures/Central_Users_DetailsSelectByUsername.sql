CREATE PROCEDURE [dbo].[Central_Users_DetailsSelectByUsername]
@UserName       NVARCHAR(250),
@PropertyId INT
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE @UserId INT
	SET @UserId=ISNULL((SELECT Id FROM [CentralAccessDB].[dbo].[Central_Users] WHERE UserName = @Username),0)

	IF(@UserId>0)
	BEGIN
		SELECT U.UserId, 
		U.PropertyId, 
		(SELECT Username FROM [CentralAccessDB].[dbo].[Central_Users] WHERE Id=@UserId) AS UserName, 
		(SELECT Username FROM [CentralAccessDB].[dbo].[Central_Users] WHERE Id=@UserId) AS UserDisplayName, 
		(SELECT IsActive FROM [CentralAccessDB].[dbo].[Central_Users] WHERE Id=@UserId) AS IsActive,
		(SELECT *
		FROM [CentralAccessDB].[dbo].[Central_Properties] P
		WHERE P.Id = @PropertyId  FOR JSON AUTO ) AS 'selectedLoggedProperty',

		P.Name AS 'Property'
		FROM [CentralAccessDB].[dbo].[Central_UserWiseProperties]  U
		LEFT JOIN [CentralAccessDB].[dbo].[Central_Properties] AS P ON P.Id = U.PropertyId 
		WHERE U.[UserId] = @UserId AND U.PropertyId=@PropertyId
	END
	ELSE
	BEGIN
		RAISERROR('Invalid User.',16,1)
	END

END

GO

