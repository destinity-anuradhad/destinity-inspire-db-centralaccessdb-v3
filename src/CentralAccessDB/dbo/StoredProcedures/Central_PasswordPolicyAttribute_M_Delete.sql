

-- =============================================
-- Author		: Ayomi Gunasekara
-- Create date	: 2020/11/21
-- Description	: Central Password Policy Attribute DELETE
-- =============================================
CREATE PROCEDURE  [dbo].[Central_PasswordPolicyAttribute_M_Delete] 
	@Id	INT
AS
BEGIN
	
	SET NOCOUNT ON;
	DELETE FROM Central_PasswordPolicyAttribute
	WHERE Id=@Id
END

GO

