

-- =============================================
-- Author		: Ayomi Gunasekara
-- Create date	: 2020/11/21
-- Description	: Central Password Policy Attribute Search
-- =============================================
CREATE PROCEDURE [dbo].[Central_PasswordPolicyAttribute_M_Search]
	@Keyword  NVARCHAR(100) = ''
AS
BEGIN
	
	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * 
	FROM Central_PasswordPolicyAttribute
	WHERE	LEN(@Keyword) = 0
	OR 
	(	Id LIKE '%'+@Keyword+'%'
		OR Name LIKE '%'+@Keyword+'%'		
	)
END

GO

