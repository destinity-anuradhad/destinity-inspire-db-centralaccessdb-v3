CREATE PROCEDURE [dbo].[Central_UserRoles_M_Search]--''
@Keyword  NVARCHAR(100) = ''
AS
BEGIN

--Stehani
-- @Nov 10 2020  7:50PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * 
	FROM Central_UserRoles
	WHERE	LEN(@Keyword) = 0
	OR 
	(	Id LIKE '%'+@Keyword+'%'
		OR GroupId LIKE '%'+@Keyword+'%'
		OR Name LIKE '%'+@Keyword+'%'
		OR PasswordPolicyId LIKE '%'+@Keyword+'%'
		OR IsActive LIKE '%'+@Keyword+'%'
		OR CreatedUserId LIKE '%'+@Keyword+'%'
		OR ModifiedUserId LIKE '%'+@Keyword+'%'
		OR CreatedDate LIKE '%'+@Keyword+'%'
		OR ModifiedDate LIKE '%'+@Keyword+'%'
	)
END

GO

