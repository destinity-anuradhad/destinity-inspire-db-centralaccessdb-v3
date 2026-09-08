
--Report_PropertWiseUserDetails 2
CREATE PROCEDURE [dbo].[Report_PropertWiseUserDetails]
@PropertyId INT
AS
BEGIN
	

	CREATE TABLE #TempPropertyWiseUsers (
		UserId INT
	)

	INSERT INTO #TempPropertyWiseUsers
	SELECT [UserId]
	FROM [dbo].[Central_UserWiseProperties]
	WHERE [PropertyId] = @PropertyId

	CREATE TABLE #TempModuleLoginDetails (
		UserId INT,
		TxnDateTime DATETIME
	)

	INSERT INTO #TempModuleLoginDetails
	(UserId,TxnDateTime)
	SELECT 
	UserId,TxnDateTime
	FROM [dbo].[Central_UserWiseModuleLogin] WITH(NOLOCK)
	WHERE PropertyId=@PropertyId 

	INSERT INTO #TempModuleLoginDetails
	(UserId,TxnDateTime)
	SELECT 
	UserId,TxnDateTime
	FROM [dbo].[Central_UserWiseModuleLogin_History] WITH(NOLOCK)
	WHERE PropertyId=@PropertyId 

	CREATE TABLE #TempLogIds (
		Id INT
	)

	INSERT INTO #TempLogIds
	SELECT MAX(Id)
	FROM Central_User_Activation_Log WITH(NOLOCK)
	WHERE IsActive =0
	GROUP BY UserId

	INSERT INTO #TempLogIds
	SELECT MAX(Id)
	FROM Central_User_Activation_Log WITH(NOLOCK)
	WHERE IsActive =1
	GROUP BY UserId


	CREATE TABLE #TempCentral_User_Activation_Log_LastDeactivation_Id
	( 
		ModifiedDateTime			DATETIME,
		UserId						INT,
		ModifiedUserId				INT,
		ModifiedUser				NVARCHAR(50)
	)
	
	
	INSERT INTO #TempCentral_User_Activation_Log_LastDeactivation_Id
	(ModifiedDateTime, UserId,ModifiedUserId,ModifiedUser)
	SELECT A.ModifiedDateTime,A.UserId,A.ModifiedUserId,F.UserName
	FROM Central_User_Activation_Log A WITH(NOLOCK)
	INNER JOIN #TempLogIds B ON A.Id=B.Id 
	INNER JOIN Central_Users F  WITH (NOLOCK) ON F.Id=A.ModifiedUserId
	WHERE A.IsActive =0

	CREATE TABLE #TempCentral_User_Activation_Log_LastActivation_Id
	( 
		ModifiedDateTime			DATETIME,
		UserId						INT,
		ModifiedUserId				INT,
		ModifiedUser				NVARCHAR(50)
	)
	
	
	INSERT INTO #TempCentral_User_Activation_Log_LastActivation_Id
	(ModifiedDateTime, UserId,ModifiedUserId,ModifiedUser)
	SELECT A.ModifiedDateTime,A.UserId,A.ModifiedUserId,F.UserName
	FROM Central_User_Activation_Log A WITH(NOLOCK)
	INNER JOIN #TempLogIds B ON A.Id=B.Id 
	INNER JOIN Central_Users F  WITH (NOLOCK) ON F.Id=A.ModifiedUserId
	WHERE A.IsActive =1

	CREATE TABLE #TempPropertyWiseUserWiseModuels (
			UserId INT,
			ModuleId	INT,
			PropertyId INT
	)

	INSERT INTO #TempPropertyWiseUserWiseModuels
	SELECT DISTINCT UserId, ModuleId, PropertyId 
	from CentralAccessDB..Central_UserWiseModules A WITH(NOLOCK)
	where PropertyId =@PropertyId


	CREATE TABLE #TempPropertyWiseModuels (
		UserId INT,
		ModulesAllocated NVARCHAR(MAX)
	)


	INSERT INTO #TempPropertyWiseModuels
	SELECT 
	CU.UserId,		
	(
		SELECT  DISTINCT      
		STUFF((SELECT DISTINCT ', ' + B.Name [text()]
		FROM #TempPropertyWiseUserWiseModuels A WITH(NOLOCK)			
		INNER JOIN CentralAccessDB..Central_Modules B WITH(NOLOCK) ON A.ModuleId=B.Id	
		WHERE A.UserId = CU.UserId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ')
	) AS 'ModulesAllocated'
	FROM #TempPropertyWiseUsers CU


	CREATE TABLE #TempPropertyWiseRoles (
		UserId INT,
		ModulesAllocated NVARCHAR(MAX)
	)

	INSERT INTO #TempPropertyWiseRoles
	SELECT 
	CU.UserId,	
	(
		SELECT  DISTINCT      
		STUFF((SELECT DISTINCT ', ' + B.Name [text()]
		FROM CentralAccessDB..Central_UserWiseUserRoles A WITH(NOLOCK)
		INNER JOIN CentralAccessDB..Central_UserRoles B WITH(NOLOCK) ON A.UserRoleId=B.Id
		WHERE A.UserId = CU.UserId
		FOR XML PATH(''), TYPE)
		.value('.','NVARCHAR(MAX)'),1,2,' ')
	)
	FROM #TempPropertyWiseUsers CU

	CREATE TABLE #TempUserWiseProperties (
		UserId INT,
		PropertiesAllocated NVARCHAR(MAX)
	)

	INSERT INTO #TempUserWiseProperties
	SELECT 
	CU.UserId,	
	(
		SELECT  DISTINCT      
		STUFF((SELECT DISTINCT ', ' + B.Code [text()]
		FROM CentralAccessDB..Central_UserWiseProperties A WITH(NOLOCK)
		INNER JOIN CentralAccessDB..Central_Properties B WITH(NOLOCK) ON A.PropertyId=B.Id
		WHERE A.UserId = CU.UserId
		FOR XML PATH(''), TYPE)
		.value('.','NVARCHAR(MAX)'),1,2,' ')
	)
	FROM #TempPropertyWiseUsers CU


	SELECT DISTINCT
	CU.FullName AS 'Full Name',
	CU.UserName AS 'User Name',
	CU.EmpNumber AS 'Employee Number',
	CU.LeagalIdnumber AS 'NIC',
	CD.Name AS 'Department',
	CDE.Name AS 'Designation',
	CONVERT(DATE,CU.CreatedDate) AS 'Creation Date',
	PWR.ModulesAllocated AS 'Allocated Roles',
	PWM.ModulesAllocated AS 'Allocated Modules',
	UWP.PropertiesAllocated AS 'Allocated Properties',
	CU.ModifiedDate AS 'Modification Date',
	CONVERT(DATE,CU.TerminationDate) AS 'Terminated Date',
	CASE WHEN CU.IsActive=1 THEN 'Active' ELSE 'Inactive' END AS 'Ststus',
	CASE WHEN CU.IsPermanentlyLocked=1 THEN 'Locked' ELSE 'UnLocked' END AS 'Temporary or Permanent Lock User Status',
	(SELECT TOP 1 TxnDateTime FROM  #TempModuleLoginDetails WHERE UserId=CU.Id ORDER BY TxnDateTime DESC ) AS 'Last Login Date'
	,C.[ModifiedDateTime] As LastDeactivationDateTime,
	ISNULL(C.ModifiedUser,'') AS LastDectivationUser,
	D.[ModifiedDateTime],'' As LastActivationDateTime,
	ISNULL(D.ModifiedUser,'') AS LastActivationUser
	FROM Central_Users CU WITH(NOLOCK)
	--INNER JOIN Central_UserWiseProperties UWP WITH(NOLOCK) ON CU.Id=UWP.UserId
	INNER JOIN Central_Departments CD WITH(NOLOCK) ON CD.Id=CU.DepartmentId
	INNER JOIN Central_Designations CDE WITH(NOLOCK) ON CDE.Id=CU.DesignationId
	INNER JOIN #TempPropertyWiseModuels  PWM ON PWM.UserId = CU.Id
	INNER JOIN #TempPropertyWiseRoles PWR ON PWR.UserId = CU.Id
	INNER JOIN #TempUserWiseProperties UWP ON UWP.UserId=CU.Id
	LEFT JOIN #TempCentral_User_Activation_Log_LastDeactivation_Id C WITH (NOLOCK) ON C.UserId = CU.Id
	LEFT JOIN #TempCentral_User_Activation_Log_LastActivation_Id D WITH(NOLOCK) ON D.UserId = CU.Id
	--LEFT JOIN Central_Users E  WITH (NOLOCK) ON E.Id=C.ModifiedUserId
	--LEFT JOIN Central_Users F  WITH (NOLOCK) ON F.Id=D.ModifiedUserId
	--WHERE UWP.PropertyId=@PropertyId

	DROP TABLE #TempLogIds
	DROP TABLE #TempCentral_User_Activation_Log_LastDeactivation_Id
	DROP TABLE #TempCentral_User_Activation_Log_LastActivation_Id
	DROP TABLE #TempModuleLoginDetails
	DROP TABLE #TempPropertyWiseModuels
	DROP TABLE #TempPropertyWiseUsers
	DROP TABLE #TempPropertyWiseRoles

END

GO

