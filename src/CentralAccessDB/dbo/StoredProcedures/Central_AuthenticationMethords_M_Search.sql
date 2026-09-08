
CREATE PROCEDURE [dbo].[Central_AuthenticationMethords_M_Search]
@Keyword  NVARCHAR(100) = ''
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:35PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * 
	FROM Central_AuthenticationMethords
	WHERE	LEN(@Keyword) = 0
	OR 
	(	Id LIKE '%'+@Keyword+'%'
		OR Name LIKE '%'+@Keyword+'%'
		OR IsActive LIKE '%'+@Keyword+'%'
	)
END

GO

