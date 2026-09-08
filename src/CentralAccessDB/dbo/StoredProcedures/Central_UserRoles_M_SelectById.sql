
CREATE PROCEDURE [dbo].[Central_UserRoles_M_SelectById]
@Id  INT
AS
BEGIN

--EXEC Central_UserRoles_M_SelectById @Id=2
--Stehani
-- @Nov  9 2020 10:45AM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DECLARE @ModuleId INT

	--SET @ModuleId = (SELECT [ModuleId] FROM [dbo].[Central_UserRoleWiseMenuItems] WHERE [UserRoleId] = @Id)

	SELECT
		[Id],
		[Name],
		[IsActive],
		HierarchicalLevel,
	
	(
	SELECT
		A.[UserRoleId],
		A.[PropertyId],
	(SELECT [Name] FROM [dbo].[Central_Properties] WHERE [Id]= A.[PropertyId]) AS 'Property'
	FROM [dbo].[Central_UserRoleWiseProperties] A
	WHERE A.[UserRoleId] = @Id
	FOR JSON AUTO 
	) AS UserRoleWiseProperties,

	(
	SELECT
		B.[UserRoleId],
		B.[ModuleId],
		B.[MenuItemId]
	--(SELECT [Name] FROM [dbo].[Central_Modules] WHERE [Id]= B.[ModuleId]) AS 'Module',
	--(SELECT [Name] FROM [dbo].[Central_MenuItems] WHERE [MenuItemId] = B.[MenuItemId] AND [ModuleId] = B.ModuleId) AS 'MenuItem'
	FROM [dbo].[Central_UserRoleWiseMenuItems] B
	WHERE B.[UserRoleId] = @Id 
	FOR JSON AUTO 
	) AS UserRoleWiseMenuItems

	FROM Central_UserRoles 
	WHERE Id=@Id
END

GO

