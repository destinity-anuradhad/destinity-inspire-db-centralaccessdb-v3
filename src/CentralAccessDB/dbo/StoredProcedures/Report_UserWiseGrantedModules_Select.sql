CREATE PROCEDURE [dbo].[Report_UserWiseGrantedModules_Select]
	@UserId INT
AS
BEGIN
	SELECT DISTINCT A.ModuleId,
	(SELECT Name FROM Central_Modules WHERE Id=A.ModuleId) AS ModuleName
	FROM Central_UserWiseModules A
	WHERE A.UserId=@UserId
END

GO

