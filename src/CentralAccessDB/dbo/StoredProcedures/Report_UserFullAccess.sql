---Report_UserFullAccess 1
CREATE   PROCEDURE [dbo].[Report_UserFullAccess]
	@UserId	INT=-1
AS
BEGIN


	CREATE TABLE #tempUserFullAccess
	(
		FullName			NVARCHAR(500),
		Page				NVARCHAR(500),
		Module				NVARCHAR(500),
		AssignedUser		NVARCHAR(500),
		AssignedDate		DATETIME,
		GrantType			NVARCHAR(50)
	)

	INSERT INTO #tempUserFullAccess
	(
		FullName		
		,Page			
		,Module			
		,AssignedUser	
		,AssignedDate	
		,GrantType		
	)
	SELECT
	D.FullName,
	ISNULL(C.Name,'') AS Page,
	E.Name AS Module,
	F.UserName AS AssignedUser,
	B.CreatedDate AS AssignedDate,
	'Role' AS GrantType
	FROM Central_UserWiseUserRoles  B WITH (NOLOCK)
	INNER JOIN Central_UserRoleWiseMenuItems G WITH(NOLOCK) ON B.UserRoleId = G.UserRoleId
	INNER JOIN Admin_Nav_AreasWisePages C WITH(NOLOCK) ON C.Id = G.MenuItemId
	INNER JOIN Central_Users D WITH(NOLOCK) ON D.Id = B.UserId
	INNER JOIN Central_Modules E WITH(NOLOCK) ON E.Id = G.ModuleId
	INNER JOIN Central_Users F WITH(NOLOCK) ON F.Id = B.CreatedUserId
	WHERE (@UserId=-1 OR B.UserId=@UserId)
	ORDER BY E.Name,C.Name


	INSERT INTO #tempUserFullAccess
	(
		FullName		
		,Page			
		,Module			
		,AssignedUser	
		,AssignedDate	
		,GrantType		
	)
	SELECT
	D.FullName,
	ISNULL(C.Name,'') AS Page,
	E.Name AS Module,
	F.UserName AS AssignedUser,
	B.ModifiedDate AS AssignedDate,
	'Individual' AS GrantType
	FROM Central_UserWiseIndividualMenuItems  B WITH (NOLOCK)
	INNER JOIN Admin_Nav_AreasWisePages C WITH(NOLOCK) ON C.Id = B.MenuItemId
	INNER JOIN Central_Users D WITH(NOLOCK) ON D.Id = B.UserId
	INNER JOIN Central_Modules E WITH(NOLOCK) ON E.Id = B.ModuleId
	INNER JOIN Central_Users F WITH(NOLOCK) ON F.Id = B.CreatedUserId
	WHERE (@UserId=-1 OR B.UserId=@UserId)
	ORDER BY E.Name,C.Name

	SELECT * FROM #tempUserFullAccess
	ORDER BY Module,Page

END

GO

