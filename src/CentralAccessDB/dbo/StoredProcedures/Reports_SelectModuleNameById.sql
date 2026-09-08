CREATE PROCEDURE [dbo].[Reports_SelectModuleNameById]
@ModuleId INT
AS
BEGIN
	SELECT Name FROM Central_Modules WHERE Id=@ModuleId
END

GO

