
CREATE PROCEDURE [dbo].[Central_UserRoleWiseProperties_M_Search]
@Keyword  NVARCHAR(100) = ''
AS
BEGIN


--Stehani
-- @Nov  9 2020 10:58AM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * 
	FROM Central_UserRoleWiseProperties
	WHERE	LEN(@Keyword) = 0
	OR 
	(
		UserRoleId LIKE '%'+@Keyword+'%'
		OR PropertyId LIKE '%'+@Keyword+'%'
		OR CreatedUserId LIKE '%'+@Keyword+'%'
		OR ModifiedUserId LIKE '%'+@Keyword+'%'
		OR CreatedDate LIKE '%'+@Keyword+'%'
		OR ModifiedDate LIKE '%'+@Keyword+'%'
	)
END

GO

