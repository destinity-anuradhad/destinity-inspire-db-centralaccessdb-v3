
-- =============================================
-- Author		:	Sweeni 
-- Create date	:	2020-11-11
-- Description	:	Central_Modules_T_Select_ByUserId
-- =============================================
--EXEC Central_Modules_T_Select_ByUserId @UserId=5760,@PropertyId=3
CREATE PROCEDURE [dbo].[Central_Modules_T_Select_ByUserId]--23,2
	@UserId INT,
	@PropertyId INT
AS
BEGIN
	
	SET NOCOUNT ON;

	declare @IsStagingUser bit = 0
	
	select 
	@IsStagingUser = IsStagingUser 
	from Central_Users with(nolock) 
	where Id = @UserId

	SELECT DISTINCT 
	[Id], 
	[Name], 
	[IsActive],
	[Color], 
	[Image],
	(CASE @IsStagingUser WHEN 1 THEN [StagingPublishUrl] ELSE [PublishUrl] END) as PublishUrl, 
	[Code],
	[OrderId], 
	[StagingPublishUrl]
	FROM [dbo].[Central_Modules] CM with (nolock) 
	INNER JOIN [dbo].[Central_UserWiseModules] AS CUWM with (nolock) ON CM.Id = CUWM.ModuleId
	--INNER JOIN [dbo].[Central_PropertyWiseModules] AS CPWM ON CUWM.ModuleId = CPWM.ModuleId
	WHERE CUWM.UserId =  @UserId 
	--AND CUWM.PropertyId=@PropertyId

	--SELECT DISTINCT CUWM.*
	--FROM Central_UserWiseModules CUWM
	--INNER JOIN [dbo].[Central_Modules] CM ON CM.Id=CUWM.ModuleId
	--WHERE CUWM.UserId=@UserId
END
--SELECT * FROM Central_UserWiseModules WHERE UserId=108

GO

