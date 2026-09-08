
CREATE PROCEDURE [dbo].[Central_Departments_M_Search]
@Keyword  NVARCHAR(100) = ''
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:40PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * 
	FROM Central_Departments
	WHERE	LEN(@Keyword) = 0
	OR 
	(	Id LIKE '%'+@Keyword+'%'
		OR GroupId LIKE '%'+@Keyword+'%'
		OR Name LIKE '%'+@Keyword+'%'
		OR IsActive LIKE '%'+@Keyword+'%'
		OR CreatedUserId LIKE '%'+@Keyword+'%'
		OR ModifiedUserId LIKE '%'+@Keyword+'%'
		OR CreatedDate LIKE '%'+@Keyword+'%'
		OR ModifiedDate LIKE '%'+@Keyword+'%'
	)
END

GO

