---exec Central_UserWiseModuleLogin_T_SelectLatestTokenByUserId 'thiruni',2,53,'123'
CREATE PROCEDURE [dbo].[Central_UserWiseModuleLogin_T_SelectLatestTokenByUserId]
	@Username NVARCHAR(500),
	@ModuleId INT = -2,
	@PropertyId INT=-2,
	@Password NVARCHAR(max)
AS
BEGIN
	DECLARE @UserId INT
	SET @UserId=ISNULL((SELECT Id FROM [dbo].[Central_Users] WHERE UserName = @Username AND Password = (SELECT DBO.GetEncryption(@Password, @Username))),0)

	IF(@UserId>0)
	BEGIN
		SELECT TOP 1
			UserId,
			(SELECT Username FROM Central_Users WHERE Id=@UserId) AS UserName,
			ModuleId,
			ISNULL((SELECT Name FROM Central_Modules WHERE Id=@ModuleId),'') AS ModuleName,
			PropertyId,
			ISNULL((SELECT Name FROM Central_Properties WHERE Id=@PropertyId),'') AS PropertyName,
			Uuid AS Token
		FROM [CentralAccessDB].[dbo].[Central_UserWiseModuleLogin]
		WHERE (UserId = @UserId)
		AND (@ModuleId=-2 OR ModuleId=@ModuleId)
		AND (@PropertyId = -2 OR PropertyId=@PropertyId)
		ORDER BY  TxnDateTime DESC
	END
	
	
END

GO

