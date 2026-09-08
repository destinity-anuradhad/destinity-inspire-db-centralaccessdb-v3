---Report_UserLoginDetails 1
CREATE   PROCEDURE [dbo].[Report_UserLoginDetails]
	@UserId	INT=-1
AS
BEGIN


	CREATE TABLE #tempUserLoginDetails
	(
		[UserId]						INT,
		[PropertyId]					INT,
		[ModuleId]						INT,
		[TxnDateTime]					DATETIME,
		[LastActiveDateTime]			DATETIME,
		[LastCashierLoggedInDateTime]	DATETIME
	)

	CREATE TABLE #tempUserLoginDetailsFinal
	(
		[UserId]						INT,
		[PropertyId]					INT,
		[ModuleId]						INT,
		[TxnDateTime]					DATETIME,
		[LastActiveDateTime]			DATETIME,
		[LastCashierLoggedInDateTime]	DATETIME,
		FullName						NVARCHAR(500),
		Property						NVARCHAR(500),
		Module							NVARCHAR(500),
		UserName						NVARCHAR(500),
		EmpNo							NVARCHAR(100)
	)

	INSERT INTO #tempUserLoginDetails
	(
		[UserId]					
		,[PropertyId]				
		,[ModuleId]					
		,[TxnDateTime]				
		,[LastActiveDateTime]		
		,[LastCashierLoggedInDateTime]
	)
	SELECT
	A.UserId,
	A.PropertyId,
	A.ModuleId,
	A.TxnDateTime,
	A.LastActiveDateTime,
	A.LastCashierLoggedInDateTime
	FROM Central_UserWiseModuleLogin A WITH (NOLOCK)
	WHERE (@UserId=-1 OR A.UserId=@UserId)

	INSERT INTO #tempUserLoginDetails
	(
		[UserId]					
		,[PropertyId]				
		,[ModuleId]					
		,[TxnDateTime]				
		,[LastActiveDateTime]		
		,[LastCashierLoggedInDateTime]
	)
	SELECT
	A.UserId,
	A.PropertyId,
	A.ModuleId,
	A.TxnDateTime,
	A.LastActiveDateTime,
	A.LastCashierLoggedInDateTime
	FROM Central_UserWiseModuleLogin_History A WITH (NOLOCK)
	WHERE (@UserId=-1 OR A.UserId=@UserId)

	INSERT INTO #tempUserLoginDetailsFinal
	(
		[UserId]					
		,[PropertyId]				
		,[ModuleId]					
		,[TxnDateTime]			
		,[LastActiveDateTime]		
		,[LastCashierLoggedInDateTime]
		,FullName
		,Property
		,Module
		,UserName
		,EmpNo
	)
	SELECT
	A.UserId,
	A.PropertyId,
	A.ModuleId,
	A.TxnDateTime,
	A.LastActiveDateTime,
	A.LastCashierLoggedInDateTime,
	B.FullName,
	D.Name,
	C.Name,
	B.UserName,
	B.EmpNumber
	FROM #tempUserLoginDetails A WITH (NOLOCK)
	INNER JOIN Central_Users B WITH(NOLOCK) ON A.UserId = B.Id
	INNER JOIN Central_Modules C WITH(NOLOCK) ON A.ModuleId = C.Id
	INNER JOIN Central_Properties D WITH(NOLOCK) ON A.PropertyId = D.Id
	WHERE (@UserId=-1 OR A.UserId=@UserId)
	ORDER BY B.FullName, A.LastActiveDateTime DESC

	SELECT * FROM #tempUserLoginDetailsFinal

	DROP TABLE #tempUserLoginDetails
	DROP TABLE #tempUserLoginDetailsFinal

END

GO

