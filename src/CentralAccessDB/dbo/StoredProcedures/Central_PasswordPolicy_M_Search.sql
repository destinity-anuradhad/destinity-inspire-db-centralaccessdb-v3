
CREATE PROCEDURE [dbo].[Central_PasswordPolicy_M_Search]
@Keyword  NVARCHAR(100) = ''
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:48PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * 
	FROM Central_PasswordPolicy
	WHERE	LEN(@Keyword) = 0
	OR 
	(	Id LIKE '%'+@Keyword+'%'
		OR GroupId LIKE '%'+@Keyword+'%'
		OR Name LIKE '%'+@Keyword+'%'
		OR CreatedUserId LIKE '%'+@Keyword+'%'
		OR ModifiedUserId LIKE '%'+@Keyword+'%'
		OR CreatedDate LIKE '%'+@Keyword+'%'
		OR ModifiedDate LIKE '%'+@Keyword+'%'
	)
END

GO

