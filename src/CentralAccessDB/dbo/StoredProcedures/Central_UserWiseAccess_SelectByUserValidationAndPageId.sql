
---exec Central_UserWiseAccess_SelectByUserValidationAndPageId 'jetwing','jetwing',1,8,-2
CREATE PROCEDURE [dbo].[Central_UserWiseAccess_SelectByUserValidationAndPageId]
	@Username NVARCHAR(max),
	@Password NVARCHAR(max),
	@PageId INT,
	@ModuleId INT = -2,
	@PropertyId INT = -2
AS
BEGIN
	DECLARE @UserId INT
	DECLARE @Right	CHAR(1)

	SET @UserId=ISNULL((SELECT Id FROM [dbo].[Central_Users] with (nolock) WHERE UserName = @Username AND Password = (SELECT DBO.GetEncryption(@Password, @Username))),0)
	SET @Right = 'S'

	IF(@UserId>0)
	BEGIN
		IF EXISTS (	select 1 
				from  [dbo].[Admin_Nav_AreasWisePages] with (nolock)
				where (Id = @PageId)
				and IsActive = 0 AND ModuleId=@ModuleId
		)
		BEGIN
			SELECT 1
		END
		ELSE 
		BEGIN		
			SELECT ISNULL(SUM(X.authorized),0)  
			From(
 				SELECT 
				CASE(@Right)
				WHEN 'S' THEN 1
				WHEN 'I' THEN 1
				WHEN 'D' THEN 1
				WHEN 'U' THEN 1
				ELSE 0
				END  AS  authorized
				FROM
				[dbo].[Central_UserWiseIndividualMenuItems] with (nolock)
				WHERE UserId = @UserId  AND ModuleId=@ModuleId
				AND (	MenuItemId = @PageId 
						--OR MenuItemId IN (	SELECT [value]
						--				FROM OPENJSON (@AltPages)
						--			)
					)

				UNION

				SELECT 
				CASE(@Right)
				WHEN 'S' THEN 1
				WHEN 'I' THEN 1
				WHEN 'D' THEN 1
				WHEN 'U' THEN 1
				ELSE 0
				END AS  authorized
				FROM
				[dbo].[Central_UserRoleWiseMenuItems] AS URWP with (nolock)	
				INNER JOIN Central_UserWiseUserRoles AS UWR with (nolock) ON UWR.UserRoleId = URWP.UserRoleId
				WHERE UWR.UserId = @UserId  AND URWP.ModuleId=@ModuleId
				AND (	URWP.MenuItemId = @PageId 
						--OR URWP.MenuItemId  IN (	SELECT [value]
						--				FROM OPENJSON (@AltPages)
						--			)
					)
			)  AS X

		END
	END
	ELSE
	BEGIN
		RAISERROR('Invalid User Credentials.',16,1);
	END
END

GO

