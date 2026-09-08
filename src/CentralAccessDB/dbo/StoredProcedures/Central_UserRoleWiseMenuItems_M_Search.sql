
CREATE PROCEDURE [dbo].[Central_UserRoleWiseMenuItems_M_Search]
@Keyword  NVARCHAR(100) = ''
AS
BEGIN


--Stehani
-- @Nov  9 2020 12:53PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * 
	FROM Central_UserRoleWiseMenuItems
	WHERE	LEN(@Keyword) = 0
	OR 
	(	Id LIKE '%'+@Keyword+'%'
		OR UserRoleId LIKE '%'+@Keyword+'%'
		OR PropertyId LIKE '%'+@Keyword+'%'
		OR ModuleId LIKE '%'+@Keyword+'%'
		OR MenuItemId LIKE '%'+@Keyword+'%'
	)
END

GO

