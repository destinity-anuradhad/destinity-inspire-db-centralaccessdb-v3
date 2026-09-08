
-- Report_CentralUserWise_IndividualAccessPages 3

-- Report_CentralUserWise_IndividualAccessPages 0
CREATE PROCEDURE [dbo].[Report_CentralUserWise_IndividualAccessPages]
	@ModuleId	INT
AS
BEGIN
	
	CREATE TABLE #tempCentral_UserWiseIndividualMenuItems
	(
		UserId				INT,
		ModuleId			INT,
		ModifiedUserId		INT,
		MenuItemId			INT,
		CreatedDate			DATETIME
	)

	INSERT INTO #tempCentral_UserWiseIndividualMenuItems
	(UserId,ModuleId,ModifiedUserId,MenuItemId,CreatedDate)
	SELECT UserId,ModuleId,ModifiedUserId,MenuItemId,CreatedDate
	FROM Central_UserWiseIndividualMenuItems WITH(NOLOCK)
	WHERE ModuleId=@ModuleId

	SELECT DISTINCT
	B.FullName AS [User],
	E.FullName AS ModifiedUser,
	C.Name AS Module,
	D.Name AS Page,
	A.CreatedDate,
	F.PropertyId,
	G.Name AS Property
	FROM #tempCentral_UserWiseIndividualMenuItems A WITH(NOLOCK)
	INNER JOIN Central_UserWiseProperties F WITH(NOLOCK) ON F.UserId = A.UserId
	INNER JOIN Central_Users B WITH(NOLOCK) ON A.UserId = B.Id
	INNER JOIN Central_Modules C WITH(NOLOCK) ON C.Id = A.ModuleId
	INNER JOIN Admin_Nav_AreasWisePages D WITH(NOLOCK) ON D.Id = A.MenuItemId AND D.ModuleId = A.ModuleId
	INNER JOIN Central_Users E WITH(NOLOCK) ON E.Id = A.ModifiedUserId
	INNER JOIN Central_Properties G WITH(NOLOCK) ON G.Id = F.PropertyId
	--WHERE A.ModuleId=@ModuleId
	--AND E.Id=4207
	ORDER BY Module,Page

	DROP TABLE #tempCentral_UserWiseIndividualMenuItems
END

GO

