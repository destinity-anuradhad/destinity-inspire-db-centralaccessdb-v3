

CREATE PROCEDURE [dbo].[PropertiesWiseUserDetails]
@Properties NVARCHAR(MAX) = '[{2}]'
AS
BEGIN
	-- Replace curly braces with square brackets to make it a valid JSON array
	SET @Properties = REPLACE(REPLACE(@Properties, '{', '['), '}', ']');

	-- Remove the outer square brackets
	SET @Properties = SUBSTRING(@Properties, 2, LEN(@Properties) - 2);

	-- Split the string by comma and insert into a table
	DECLARE @Delimiter CHAR(1) = ',';
	DECLARE @StartIndex INT = 1;
	DECLARE @EndIndex INT;
	DECLARE @Value NVARCHAR(MAX);

	-- Create a table variable to hold the parsed values
	DECLARE @ParsedProperties TABLE (PropertyValue INT);

	WHILE @StartIndex <= LEN(@Properties)
	BEGIN
		SET @EndIndex = CHARINDEX(@Delimiter, @Properties, @StartIndex);
		IF @EndIndex = 0
			SET @EndIndex = LEN(@Properties) + 1;
    
		SET @Value = SUBSTRING(@Properties, @StartIndex, @EndIndex - @StartIndex);
    
		-- Remove leading and trailing spaces and square brackets
		SET @Value = LTRIM(RTRIM(REPLACE(REPLACE(@Value, '[', ''), ']', '')));
    
		-- If the value is not empty and it represents a valid integer
		IF @Value <> '' AND ISNUMERIC(@Value) = 1
			INSERT INTO @ParsedProperties (PropertyValue) VALUES (CAST(@Value AS INT));
    
		SET @StartIndex = @EndIndex + 1;
	END

	CREATE TABLE #TempPropertyWiseUsers (
		UserId INT
	)

	INSERT INTO #TempPropertyWiseUsers
	SELECT [UserId]
	FROM [dbo].[Central_UserWiseProperties]
	WHERE [PropertyId] IN  (SELECT PropertyValue FROM @ParsedProperties)

	CREATE TABLE #TempModuleLoginDetails (
		UserId INT,
		TxnDateTime DATETIME
	)

	INSERT INTO #TempModuleLoginDetails
	(UserId,TxnDateTime)
	SELECT 
	UserId,TxnDateTime
	FROM [dbo].[Central_UserWiseModuleLogin] WITH(NOLOCK)
	WHERE PropertyId IN  (SELECT PropertyValue FROM @ParsedProperties)

	INSERT INTO #TempModuleLoginDetails
	(UserId,TxnDateTime)
	SELECT 
	UserId,TxnDateTime
	FROM [dbo].[Central_UserWiseModuleLogin_History] WITH(NOLOCK)
	WHERE PropertyId IN  (SELECT PropertyValue FROM @ParsedProperties)

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
	where PropertyId IN  (SELECT PropertyValue FROM @ParsedProperties)


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
		STUFF((SELECT DISTINCT ', ' + B.Name [text()]
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
	FORMAT(CONVERT(DATE,CU.CreatedDate), 'dd/MM/yyyy') AS 'Creation Date',
	ISNULL(PWR.ModulesAllocated,'') AS 'Allocated Roles',
	ISNULL(PWM.ModulesAllocated,'') AS 'Allocated Modules',
	UWP.PropertiesAllocated AS 'Allocated Properties',
	FORMAT(CU.ModifiedDate, 'dd/MM/yyyy HH:mm:ss') AS 'Modification Date',
	--ISNULL(FORMAT(CONVERT(DATE,CU.TerminationDate), 'dd/MM/yyyy'),'') AS 'Terminated Date',
	CASE WHEN CU.IsActive=1 THEN 'Active' ELSE 'Inactive' END AS 'Ststus',
	CASE WHEN CU.IsPermanentlyLocked=1 THEN 'Locked' ELSE 'UnLocked' END AS 'Temporary or Permanent Lock User Status',
	ISNULL((SELECT TOP 1 FORMAT(TxnDateTime, 'dd/MM/yyyy HH:mm:ss') FROM  #TempModuleLoginDetails WHERE UserId=CU.Id ORDER BY TxnDateTime DESC ),'') AS 'Last Login Date',
	ISNULL(FORMAT(C.[ModifiedDateTime], 'dd/MM/yyyy HH:mm:ss'),'') As LastDeactivationDateTime,
	ISNULL(C.ModifiedUser,'') AS LastDectivationUser
	--ISNULL(FORMAT(D.[ModifiedDateTime], 'dd/MM/yyyy HH:mm:ss'),'') LastActivationDateTime,
	--ISNULL(D.ModifiedUser,'') AS LastActivationUser
	FROM Central_Users CU WITH(NOLOCK)
	INNER JOIN Central_Departments CD WITH(NOLOCK) ON CD.Id=CU.DepartmentId
	INNER JOIN Central_Designations CDE WITH(NOLOCK) ON CDE.Id=CU.DesignationId
	INNER JOIN #TempPropertyWiseModuels  PWM ON PWM.UserId = CU.Id
	INNER JOIN #TempPropertyWiseRoles PWR ON PWR.UserId = CU.Id
	INNER JOIN #TempUserWiseProperties UWP ON UWP.UserId=CU.Id
	LEFT JOIN #TempCentral_User_Activation_Log_LastDeactivation_Id C WITH (NOLOCK) ON C.UserId = CU.Id
	LEFT JOIN #TempCentral_User_Activation_Log_LastActivation_Id D WITH(NOLOCK) ON D.UserId = CU.Id

	DROP TABLE #TempLogIds
	DROP TABLE #TempCentral_User_Activation_Log_LastDeactivation_Id
	DROP TABLE #TempCentral_User_Activation_Log_LastActivation_Id
	DROP TABLE #TempModuleLoginDetails
	DROP TABLE #TempPropertyWiseModuels
	DROP TABLE #TempPropertyWiseUsers
	DROP TABLE #TempPropertyWiseRoles

END

GO

