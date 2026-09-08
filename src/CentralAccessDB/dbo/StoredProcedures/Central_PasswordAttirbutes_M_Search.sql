

-- =============================================
-- Author		:	Ayomi Gunasekara
-- Create date	:	2020-11-23
-- Description	:	Central Passowrd Attribute Search
-- =============================================
CREATE PROCEDURE [dbo].[Central_PasswordAttirbutes_M_Search]
	@Keyword  NVARCHAR(100) = ''
AS
BEGIN
	
	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * 
	FROM Central_PasswordPolicy
	WHERE	LEN(@Keyword) = 0
	OR 
	(	Id LIKE '%'+@Keyword+'%'
		OR Name LIKE '%'+@Keyword+'%'		
	)
   END

GO

