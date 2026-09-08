 -- =============================================
-- Author:		Chiraj
-- Create date: 2020-10-15
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Central_UserRoles_BE_Select_ById]
@Id       INT,
@PropertyId INT 
AS
BEGIN	
	SET NOCOUNT ON;

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
	 WHERE UR.Id =@Id AND UP.PropertyId = @PropertyId

END

GO

