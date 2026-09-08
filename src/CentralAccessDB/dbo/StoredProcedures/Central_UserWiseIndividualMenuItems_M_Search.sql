
CREATE PROCEDURE [dbo].[Central_UserWiseIndividualMenuItems_M_Search]
@Keyword  NVARCHAR(100) = ''
AS
BEGIN


--Stehani
-- @Nov  9 2020  1:55PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * 
	FROM Central_UserWiseIndividualMenuItems
	WHERE	LEN(@Keyword) = 0
	OR 
	(
		PropertyId LIKE '%'+@Keyword+'%'
		OR UserId LIKE '%'+@Keyword+'%'
		OR ModuleId LIKE '%'+@Keyword+'%'
		OR MenuItemId LIKE '%'+@Keyword+'%'
		OR CreatedUserId LIKE '%'+@Keyword+'%'
		OR ModifiedUserId LIKE '%'+@Keyword+'%'
		OR CreatedDate LIKE '%'+@Keyword+'%'
		OR ModifiedDate LIKE '%'+@Keyword+'%'
	)
END

GO

