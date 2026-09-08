-- =============================================
-- Author:		Chiraj
-- Create date: 2020-10-15
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Central_Users_BE_Select_UserDetailsTemp]
@UserName		Nvarchar(50)
AS
BEGIN	
	SET NOCOUNT ON;


	SELECT U.[Id] AS  Id
		,0 AS EmployeeId
		,P.PropertyId AS PropertyId
		,0 AS ProductId
        ,[UserName] AS Username
        ,[Password] AS Password
        ,0 AS UserRoleId
		,'' AS Salt
		,'' AS Guid
		,'' AS POSPassword
		,'' AS AccessCardNo
		,0 AS IsPOSUser
		,0 AS IsUpload
		,0 AS  IsGroupUser
		,0 AS IsPasswordReset
		,U.[IsLoked] AS IsLocked
        ,U.[IsActive] AS IsActive
        ,U.[CreatedUserId] AS CreatedUserId
        ,U.[ModifiedUserId] AS LastEditedUserId
        ,U.[CreatedDate] AS CreatedDateTime
        ,U.[ModifiedDate] AS LastEditedDateTime
		, (
			  SELECT UR.[Id] AS Id
			 ,UR.[GroupId]
			 ,UR.[Name] AS Name
			 ,UR.[PasswordPolicyId]
			 ,UR.[IsActive] AS IsActive
			 ,UR.[CreatedUserId] AS CreatedUserId
			 ,UR.[ModifiedUserId] AS LastUpdatedUserId
			 ,UR.[CreatedDate] AS CreatedDateTime
			 ,UR.[ModifiedDate] AS LastUpdatedDateTime
			 ,0 AS IsUpload
			 ,UP.PropertyId AS PropertyI
			 FROM [dbo].[Central_UserRoles] UR  INNER JOIN Central_UserRoleWiseProperties UP ON UR.Id = UP.UserRoleId
			 WHERE UR.Id = U.Id AND UP.PropertyId = P.PropertyId FOR JSON AUTO
		  ) AS RolesJson  
    FROM [dbo].[Central_Users] U INNER JOIN Central_UserWiseProperties  P ON U.Id = P.UserId
	WHERE(U.Username=@UserName)

END

GO

