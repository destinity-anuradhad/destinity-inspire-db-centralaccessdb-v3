
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Central_MoveToHistory]
	
AS
BEGIN
	
	SET NOCOUNT ON;


	insert into Central_UserLoginAttempts_History
	select *
	from Central_UserLoginAttempts with(nolock)
	where TxnDateTime < CONVERT(DATE,GETDATE())


	delete A
	from Central_UserLoginAttempts A with(nolock)
	where TxnDateTime < CONVERT(DATE,GETDATE())


	insert into Central_UserWiseModuleLogin_History
	([Id], [UserId], [PropertyId], [ModuleId], [Uuid], [TxnDateTime], [BrowserKey], [SessionID], [SessionStorageId], [LocalStorageId], [Authority], [IsActive], [LastActiveDateTime], [LastCashierLoggedInDateTime])
	select [Id], [UserId], [PropertyId], [ModuleId], [Uuid], [TxnDateTime], [BrowserKey], [SessionID], [SessionStorageId], [LocalStorageId], [Authority], [IsActive], [LastActiveDateTime], [LastCashierLoggedInDateTime]
	from Central_UserWiseModuleLogin with (nolock) 
	where IsActive = 0

	insert into Central_UserWiseModuleLogin_History
	([Id], [UserId], [PropertyId], [ModuleId], [Uuid], [TxnDateTime], [BrowserKey], [SessionID], [SessionStorageId], [LocalStorageId], [Authority], [IsActive], [LastActiveDateTime], [LastCashierLoggedInDateTime])
	select [Id], [UserId], [PropertyId], [ModuleId], [Uuid], [TxnDateTime], [BrowserKey], [SessionID], [SessionStorageId], [LocalStorageId], [Authority], [IsActive], [LastActiveDateTime], [LastCashierLoggedInDateTime]
	from Central_UserWiseModuleLogin A with (nolock) 
	where DATEDIFF(MI,LastActiveDateTime,GETDATE()) > 60


	-- other modules------------------------------------------
	insert into Central_UserWiseModuleLogin_History
	([Id], [UserId], [PropertyId], [ModuleId], [Uuid], [TxnDateTime], [BrowserKey], [SessionID], [SessionStorageId], [LocalStorageId], [Authority], [IsActive], [LastActiveDateTime], [LastCashierLoggedInDateTime])
	select [Id], [UserId], [PropertyId], [ModuleId], [Uuid], [TxnDateTime], [BrowserKey], [SessionID], [SessionStorageId], [LocalStorageId], [Authority], [IsActive], [LastActiveDateTime], [LastCashierLoggedInDateTime]
	from Central_UserWiseModuleLogin A with (nolock) 
	where LastActiveDateTime IS NULL
	AND DATEDIFF(D,TxnDateTime,GETDATE()) > 1


	delete A
	from Central_UserWiseModuleLogin A with (nolock) 
	where LastActiveDateTime IS NULL
	AND DATEDIFF(D,TxnDateTime,GETDATE()) > 1

	-- end of other modules------------------------------------------

	DELETE A
	from Central_UserWiseModuleLogin A with (nolock) 
	where DATEDIFF(MI,LastActiveDateTime,GETDATE()) > 60

	delete A
	from Central_UserWiseModuleLogin  A with (nolock) 
	where IsActive = 0
   

END

GO

