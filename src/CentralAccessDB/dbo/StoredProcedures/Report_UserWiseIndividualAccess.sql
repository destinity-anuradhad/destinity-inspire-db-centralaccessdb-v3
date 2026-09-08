---Report_UserWiseIndividualAccess 1
CREATE   PROCEDURE [dbo].[Report_UserWiseIndividualAccess]
	@UserId	INT=-1
AS
BEGIN
	SELECT
	D.FullName,
	C.Name AS Page,
	E.Name AS Module,
	F.UserName AS AssignedUser,
	B.ModifiedDate AS AssignedDate
	FROM Central_UserWiseIndividualMenuItems  B WITH (NOLOCK)
	INNER JOIN Admin_Nav_AreasWisePages C WITH(NOLOCK) ON C.Id = B.MenuItemId
	INNER JOIN Central_Users D WITH(NOLOCK) ON D.Id = B.UserId
	INNER JOIN Central_Modules E WITH(NOLOCK) ON E.Id = B.ModuleId
	INNER JOIN Central_Users F WITH(NOLOCK) ON F.Id = B.CreatedUserId
	WHERE (@UserId=-1 OR B.UserId=@UserId)
	ORDER BY E.Name,C.Name

END

GO

