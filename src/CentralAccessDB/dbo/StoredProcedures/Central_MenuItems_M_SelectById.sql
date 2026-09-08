CREATE PROCEDURE [dbo].[Central_MenuItems_M_SelectById]
@ModuleId INT= -2
AS
BEGIN

--EXEC Central_MenuItems_M_SelectById @ModuleId=2
--Stehani
-- @Nov 15 2020  9:54AM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * 
	FROM Central_MenuItems 
	WHERE(@ModuleId = -2 OR @ModuleId = ModuleId)
END

GO

