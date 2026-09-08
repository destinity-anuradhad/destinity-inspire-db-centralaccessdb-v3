CREATE PROCEDURE [dbo].[Central_User_M_CashierLoginVerify]
@UserName NVARCHAR(500)

AS
BEGIN
	 DECLARE @LastActiveTime DATETIME = GETDATE()
	 DECLARE @TimeDiff INT
	 DECLARE @Settimeout INT
	 DECLARE @UserId INT
	 
	 SET @UserId=ISNULL((SELECT Id FROM [dbo].[Central_Users] WHERE UserName = @Username),0)
	 
	 SELECT TOP 1 @LastActiveTime=ISNULL([LastCashierLoggedInDateTime],DATEADD(DD,-1,GETDATE())) 
	 FROM [dbo].[Central_UserWiseModuleLogin]
	 WHERE UserId=@UserId 
	 ORDER BY [LastCashierLoggedInDateTime] DESC

	 SELECT @TimeDiff= DATEDIFF(MINUTE,@LastActiveTime, GETDATE()) 
	
	 SET @Settimeout = (SELECT TOP 1 [CashierTimeOutPeriod] FROM [dbo].[Central_CashierTimeOutSettings])
	
	 IF(@TimeDiff>@Settimeout)
	 BEGIN
		SELECT 0 AS 'TimeDifferent' 
	 END
	 ELSE
	 BEGIN
		SELECT 1 AS 'TimeDifferent' 
	 END
END
--Central_User_M_CashierLoginVerify 'sweeni','123',0

GO

