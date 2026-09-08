
CREATE PROCEDURE [dbo].[Central_UserWiseUserRoles_M_Search]
@Keyword  NVARCHAR(100) = ''
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:12PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * 
	FROM Central_UserWiseUserRoles
	WHERE	LEN(@Keyword) = 0
	OR 
	(
		 UserId LIKE '%'+@Keyword+'%'
		OR UserRoleId LIKE '%'+@Keyword+'%'
		OR GroupId LIKE '%'+@Keyword+'%'
		OR IsMainRole LIKE '%'+@Keyword+'%'
		OR CreatedUserId LIKE '%'+@Keyword+'%'
		OR ModifiedUserId LIKE '%'+@Keyword+'%'
		OR CreatedDate LIKE '%'+@Keyword+'%'
		OR ModifiedDate LIKE '%'+@Keyword+'%'
	)
END

GO

