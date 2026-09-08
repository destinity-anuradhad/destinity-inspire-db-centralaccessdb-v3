--Central_Users_T_SelectByModuleId 4,-2
CREATE PROCEDURE [dbo].[Central_Users_T_SelectByModuleId]
	@ModuleId INT,
	@PropertyId INT=-2
AS
BEGIN
	SELECT DISTINCT B.ModuleId,
	--B.PropertyId, 
	A.*
	FROM [dbo].[Central_Users] A
	INNER JOIN [dbo].[Central_UserWiseModules] B ON A.Id=B.UserId
	WHERE (@PropertyId = -2 OR B.PropertyId=@PropertyId) 
	AND ModuleId=@ModuleId
END

--EXEC Central_Users_T_SelectByModuleId @ModuleId=1,@PropertyId=-2  

GO

