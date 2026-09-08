

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--[Reports_UserWiseModules_SelectByModuleId]15,'2021-04-01 00:00:00.000','2021-04-10 00:00:00.000',1
CREATE PROCEDURE [dbo].[Reports_UserWiseModules_SelectByModuleId]--15,'2020-11-01','2020-11-18',1
	@UserId INT = -1,
	@FromDate DateTime,
	@ToDate DateTime,
	@ModuleId INT
AS
BEGIN
	SELECT L.*,P.Name As PropertyName FROM [dbo].[Central_UserWiseModuleLogin] L
	INNER JOIN Central_Properties P ON L.PropertyId = P.Id
	WHERE (ModuleId = 1) AND (UserId = 1) 
	AND (TxnDateTime BETWEEN @FromDate AND @ToDate)
	
END

GO

