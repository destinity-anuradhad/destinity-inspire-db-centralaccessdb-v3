
-- =============================================
-- Author		: Ayomi Gunasekara
-- Create date	: 2020/11/21
-- Description	: Central Password Policy Attribute Select
-- =============================================
CREATE PROCEDURE [dbo].[Central_PasswordPolicyAttribute_M_SelectAttributes] 
	
AS
BEGIN
	
	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT *
	FROM [dbo].[Central_PasswordAttirbutes]
END

GO

