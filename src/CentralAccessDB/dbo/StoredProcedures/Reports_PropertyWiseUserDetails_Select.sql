
---EXEC Reports_PropertyWiseUserDetails_Select 1
CREATE PROCEDURE [dbo].[Reports_PropertyWiseUserDetails_Select]
	@PropertyId INT
AS
BEGIN

	CREATE TABLE #TempLogIds (
		Id INT
	)

	INSERT INTO #TempLogIds
	SELECT MAX(Id)
	FROM Central_User_Activation_Log
	WHERE IsActive =0
	GROUP BY UserId

	INSERT INTO #TempLogIds
	SELECT MAX(Id)
	FROM Central_User_Activation_Log
	WHERE IsActive =1
	GROUP BY UserId


	CREATE TABLE #TempCentral_User_Activation_Log_LastDeactivation_Id
	( 
		ModifiedDateTime			DATETIME,
		UserId						INT,
		ModifiedUserId				INT
	)
	
	
	INSERT INTO #TempCentral_User_Activation_Log_LastDeactivation_Id
	(ModifiedDateTime, UserId,ModifiedUserId)
	SELECT A.ModifiedDateTime,A.UserId,A.ModifiedUserId
	FROM Central_User_Activation_Log A
	INNER JOIN #TempLogIds B ON A.Id=B.Id 
	WHERE A.IsActive =0

	CREATE TABLE #TempCentral_User_Activation_Log_LastActivation_Id
	( 
		ModifiedDateTime			DATETIME,
		UserId						INT,
		ModifiedUserId				INT
	)
	
	
	INSERT INTO #TempCentral_User_Activation_Log_LastActivation_Id
	(ModifiedDateTime, UserId,ModifiedUserId)
	SELECT A.ModifiedDateTime,A.UserId,A.ModifiedUserId
	FROM Central_User_Activation_Log A
	INNER JOIN #TempLogIds B ON A.Id=B.Id 
	WHERE A.IsActive =1
	
	DECLARE @PropertyName NVARCHAR(250)
	SELECT @PropertyName = Name FROM Central_Properties WHERE Id=@PropertyId
	 
	CREATE TABLE #tempModules
	(
		Name NVARCHAR(MAX),
		UserId		INT
	)

	INSERT INTO #tempModules
	(Name,UserId)
	SELECT DISTINCT CM.Name,CUM.UserId
    FROM Central_UserWiseModules CUM WITH (NOLOCK)
    INNER JOIN Central_Modules CM WITH (NOLOCK) ON CM.Id = CUM.ModuleId
    WHERE  EXISTS (SELECT 1 FROM Central_UserWiseProperties CUP WHERE CUP.UserId = CUM.UserId AND CUP.PropertyId = @PropertyId)

	CREATE TABLE #tempUserRoles
	(
		Name NVARCHAR(MAX),
		UserId		INT
	)

	INSERT INTO #tempUserRoles
	(Name,UserId)
	SELECT DISTINCT CR.Name,CUR.UserId
    FROM Central_UserWiseUserRoles CUR WITH (NOLOCK)
    INNER JOIN Central_UserRoles CR WITH (NOLOCK) ON CR.Id = CUR.UserRoleId
    WHERE  EXISTS (SELECT 1 FROM Central_UserWiseProperties CUP WHERE CUP.UserId = CUR.UserId AND CUP.PropertyId = @PropertyId)

   SELECT
   B.Id AS UserId,
   B.FullName,
   B.UserName,
   B.MobileNumber,
   (CASE WHEN B.IsLoked=1 THEN 'Locked' ELSE 'Unlocked' END) AS LockStatus,
   (CASE WHEN B.IsActive=1 THEN 'Active' ELSE 'Inactive' END) AS ActiveStatus,
   (SELECT UserName FROM Central_Users WHERE Id=B.CreatedUserId) AS CreatedBy,
   B.CreatedDate,
	C.[ModifiedDateTime] As LastDeactivationDateTime,
	ISNULL(E.UserName,'') AS LastDectivationUser,
	--D.[ModifiedDateTime],'' As LastActivationDateTime,
	B.[ModifiedDate] ModifiedDateTime,
	ISNULL(F.UserName,'') AS LastActivationUser,
   (SELECT Name FROM Central_Properties WHERE Id=A.PropertyId) AS Property,
   ISNULL(B.Email,'') AS Email,
   ISNULL(CD.Name,'') AS Department,
   ISNULL(CDG.Name,'') AS Designation,
   ISNULL(B.LeagalIdnumber,'') AS NIC,
   (SELECT STRING_AGG(Name,',') FROM #tempModules WHERE UserId = B.Id ) AS Modules,
   (SELECT STRING_AGG(Name,',') FROM #tempUserRoles WHERE UserId = B.Id ) AS UserRoles,
   B.EmpNumber,
   B.LastLoginDate AS LastLogin,
   B.TerminationDate
 --  (SELECT DISTINCT STRING_AGG(CM.Name, ', ') 
 --   FROM Central_UserWiseModules CUM WITH (NOLOCK)
 --   INNER JOIN Central_Modules CM WITH (NOLOCK) ON CM.Id = CUM.ModuleId
 --   INNER JOIN Central_UserWiseProperties CUP WITH (NOLOCK) ON CUP.UserId = CUM.UserId
 --   WHERE CUM.UserId = B.Id AND CUP.PropertyId = @PropertyId 
	--GROUP BY CUM.UserId
 --  ) AS Modules,
 --  (SELECT DISTINCT STRING_AGG(CR.Name, ', ') 
 --   FROM Central_UserWiseUserRoles CUR WITH (NOLOCK)
 --   INNER JOIN Central_UserRoles CR WITH (NOLOCK) ON CR.Id = CUR.UserRoleId
 --   INNER JOIN Central_UserWiseProperties CUP WITH (NOLOCK) ON CUP.UserId = CUR.UserId
 --   WHERE CUR.UserId = B.Id AND CUP.PropertyId = @PropertyId 
	--GROUP BY CUR.UserId
 --  ) AS UserRoles
 --  ( SELECT  DISTINCT STRING_AGG(CM.Name, ', ') 
 --   FROM Central_UserWiseModules CUM WITH (NOLOCK)
	--INNER JOIN Central_Modules CM WITH(NOLOCK) ON CM.Id = CUM.ModuleId
	--WHERE CUM.UserId = B.Id AND A.PropertyId=@PropertyId 
 --   GROUP BY CUM.UserId) AS Modules,
	--( SELECT DISTINCT STRING_AGG(CR.Name, ', ') 
 --   FROM Central_UserWiseUserRoles CUR WITH (NOLOCK)
	--INNER JOIN Central_UserRoles CR WITH(NOLOCK) ON CR.Id = CUR.UserRoleId
	--WHERE CUR.UserId = B.Id AND A.PropertyId=@PropertyId 
 --   GROUP BY CUR.UserId) AS UserRoles
   --STRING_AGG(CM.Name, ', ') AS Modules,
   --STRING_AGG(CR.Name, ', ') AS UserRoles
   FROM [dbo].[Central_UserWiseProperties] A
   INNER JOIN Central_Users B ON B.Id=A.UserId
   LEFT JOIN #TempCentral_User_Activation_Log_LastDeactivation_Id C WITH (NOLOCK) ON C.UserId = B.Id
   LEFT JOIN #TempCentral_User_Activation_Log_LastActivation_Id D WITH(NOLOCK) ON D.UserId = B.Id
   LEFT JOIN Central_Users E  WITH (NOLOCK) ON E.Id=C.ModifiedUserId
   LEFT JOIN Central_Users F  WITH (NOLOCK) ON F.Id=D.ModifiedUserId
   INNER JOIN Central_Departments CD WITH(NOLOCK) ON CD.Id = B.DepartmentId
   INNER JOIN Central_Designations CDG WITH(NOLOCK) ON CDG.Id = B.DesignationId
   --INNER JOIN Central_UserWiseModules CUM WITH(NOLOCK) ON CUM.UserId = B.Id
   --INNER JOIN Central_Modules CM WITH(NOLOCK) ON CM.Id = CUM.ModuleId
   --INNER JOIN Central_UserWiseUserRoles CUR WITH(NOLOCK) ON CUR.UserId = B.Id
   --INNER JOIN Central_UserRoles CR WITH(NOLOCK) ON CR.Id = CUR.UserRoleId
   WHERE A.PropertyId=@PropertyId 

   DROP TABLE #TempLogIds
   DROP TABLE #TempCentral_User_Activation_Log_LastDeactivation_Id
   DROP TABLE #TempCentral_User_Activation_Log_LastActivation_Id

END

--update Central_Users
--set CreatedUserId=4172
--where CreatedUserId=1
--select * from central_users order by id desc

GO

