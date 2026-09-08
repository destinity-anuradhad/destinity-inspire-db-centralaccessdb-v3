
CREATE PROCEDURE [dbo].[Central_UserWiseModules_M_SelectById]
@Id  INT
AS
BEGIN

--EXEC Central_UserWiseModules_M_SelectById @Id=109
--Stehani
-- @Nov  9 2020  3:22PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT DISTINCT
		A.[UserId],
		A.[ModuleId],
		--A.[PropertyId],
		A.[EncryptedModuleId],
	(SELECT [Name] FROM [dbo].[Central_Modules] WHERE [Id]=A.[ModuleId]) AS 'Name'
	FROM Central_UserWiseModules A
	WHERE [UserId]=@Id
END

GO

