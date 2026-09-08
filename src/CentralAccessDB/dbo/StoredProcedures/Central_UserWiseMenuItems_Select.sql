
-- =============================================
-- Author:		Chamathka Sooriyapala
-- Create date: 2020-11-12
-- Description:	Select use wise menu 
-- =============================================
-- EXEC Central_UserWiseMenuItems_Select 4185,8
CREATE PROCEDURE [dbo].[Central_UserWiseMenuItems_Select]--2,1
	@UserId		INT,
	@ModuleId	INT = -1
AS
BEGIN
	
	DECLARE @PropertyId INT

	SELECT TOP 1 @PropertyId = PropertyId FROM Central_UserWiseModuleLogin  with (nolock) WHERE UserId=@UserId AND ModuleId=@ModuleId
	ORDER BY Id Desc

	
	--DECLARE @ModuleId INT
	--DECLARE @UserId INT
	--SET @ModuleId = 1
	--SET @UserId = 45

	SELECT X.*
	INTO #AccessibleMenuItems
	FROM 
	(
		select A.Id AS MenuItemId 
		from [dbo].Admin_Nav_AreasWisePages A with (nolock)
		INNER JOIN  [dbo].[Central_UserRoleWiseMenuItems] B with (nolock) ON B.MenuItemId = A.Id and B.ModuleId = @ModuleId
		where B.UserRoleId IN (SELECT UserRoleId FROM Central_UserWiseUserRoles  with (nolock) WHERE UserId = @UserId)
		and A.ModuleId = @ModuleId
		--select A.Id AS MenuItemId 
		--from [dbo].[Central_UserRoleWiseMenuItems] A
		--where A.UserRoleId IN (SELECT UserRoleId FROM Central_UserWiseUserRoles WHERE UserId = @UserId)
		--and A.ModuleId = @ModuleId
		UNION
		SELECT A.MenuItemId
		FROM [dbo].[Central_UserWiseIndividualMenuItems] A  with (nolock)
		WHERE A.UserId = @UserId
		AND A.ModuleId = @ModuleId	
		AND A.PropertyId=@PropertyId

	) AS X

	--select * from #AccessibleMenuItems

	SELECT A.*, 1 AS 'Access',
	(
		SELECT B.*, 1 AS 'Access',
		(
			SELECT C.*, 
			(CASE ISNULL(D.MenuItemId,0) WHEN 0 THEN 0 ELSE 1 END) AS 'Access'
			FROM Admin_Nav_AreasWisePages C  with (nolock)
			LEFT JOIN #AccessibleMenuItems D  with (nolock) ON C.Id = D.MenuItemId
			WHERE C.ModuleId = @ModuleId
			AND C.AreaId = B.Id AND C.IsActive=1
			ORDER BY ISNULL(C.DispayOrder,99999) ASC
			FOR JSON AUTO
		) 'Pages'
		FROM Admin_Nav_MainNavigationWiseAreas B  with (nolock)
		WHERE B.ModuleId = @ModuleId
		AND B.MainNavigationId = A.Id
		AND B.IsActive = 1
		ORDER BY ISNULL(B.DisplayOrder,99999) ASC
		FOR JSON AUTO
	) As 'Areas'
	FROM Admin_Nav_MainNavigations A  with (nolock)
	WHERE ModuleId = @ModuleId
	AND A.IsMainMenuNavigation = 1
	AND A.IsActive = 1
	ORDER BY A.DisplayOrder ASC


	DROP TABLE #AccessibleMenuItems





END

GO

