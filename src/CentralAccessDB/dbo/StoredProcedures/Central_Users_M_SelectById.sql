
--exec Central_Users_M_SelectById @Id=4206 punsisi
---exec Central_Users_M_SelectById @Id=4332
CREATE PROCEDURE [dbo].[Central_Users_M_SelectById]
@Id  INT
AS
BEGIN

--EXEC Central_Users_M_SelectById @Id=4165
--Stehani
-- @Nov  9 2020  1:08PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	--DECLARE @ModuleId INT
	--SET @ModuleId = (SELECT [ModuleId] FROM [dbo].[Central_UserWiseIndividualMenuItems] WHERE [UserId] = @Id)
	
	SELECT 
	[Id],
	[UserName],
	[Password],
	[FullName],
	[EmpNumber],
	[Email],
	[MobileNumber],
	[DesignationId],
	[DepartmentId],
	[AuhenticatedMethordId],
	[IsLoked],
	[IsActive],
	[LeagalIdnumber],
	[PasswordPolicyId],
    [UniqueId],
	[CentralRemark] AS Remark,
	(
		SELECT DISTINCT
		[UserId],
		[PropertyId]
		FROM [dbo].[Central_UserWiseProperties] WITH(NOLOCK)
		WHERE [UserId] = @Id
		FOR JSON AUTO 
	) AS UserWiseProperties,
	(
		SELECT DISTINCT
		[UserId], 
		[ModuleId]
		FROM [dbo].[Central_UserWiseModules] WITH(NOLOCK)
		WHERE [UserId] = @Id
		FOR JSON AUTO 
	) AS UserWiseModules,
	(
		SELECT DISTINCT
		[UserId],
		[OutletId]
		FROM [dbo].[Central_UserWiseOutlets] WITH(NOLOCK)
		WHERE [UserId]=@Id
		FOR JSON AUTO 
	) AS UserWiseOutlets,
	(
		SELECT DISTINCT
		[UserId],
		[UserRoleId],
		[IsMainRole]
		FROM [dbo].[Central_UserWiseUserRoles] WITH(NOLOCK)
		WHERE [UserId] = @Id
		FOR JSON AUTO 
	) AS UserWiseUserRoles	
	,(
		SELECT DISTINCT
		[UserId],
		[ModuleId],
		[MenuItemId]
		FROM [dbo].[Central_UserWiseIndividualMenuItems] WITH(NOLOCK)
		WHERE [UserId] = @Id 
		FOR JSON AUTO 
	) AS UserWiseIndividualMenuItems
	,(
		SELECT DISTINCT
		[PropertyId]
		FROM [dbo].[Central_UserWiseIndividualMenuItems] WITH(NOLOCK)
		WHERE [UserId] = @Id 
		FOR JSON AUTO 
	) AS ApplicableProperties

	FROM Central_Users WITH(NOLOCK)
	WHERE Id=@Id


END

GO

