
CREATE PROCEDURE [dbo].[Central_UserWiseModules_M_Search]
@Keyword  NVARCHAR(100) = ''
AS
BEGIN


--Stehani
-- @Nov  9 2020  3:22PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * 
	FROM Central_UserWiseModules
	WHERE	LEN(@Keyword) = 0
	OR 
	(
		 UserId LIKE '%'+@Keyword+'%'
		OR PropertyId LIKE '%'+@Keyword+'%'
		OR ModuleId LIKE '%'+@Keyword+'%'
		OR CreatedUserId LIKE '%'+@Keyword+'%'
		OR ModifiedUserId LIKE '%'+@Keyword+'%'
		OR CreatedDate LIKE '%'+@Keyword+'%'
		OR ModifiedDate LIKE '%'+@Keyword+'%'
	)
END

GO

