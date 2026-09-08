
-- =============================================
-- Author		: Ayomi Gunasekara
-- Create date	: 2020/11/21
-- Description	: Central Password Policy Attribute SelectById
-- =============================================
---EXEC Central_PasswordPolicyAttribute_M_SelectById @Id = 2
CREATE PROCEDURE [dbo].[Central_PasswordPolicyAttribute_M_SelectById]
	@Id INT
AS
BEGIN
	SELECT * FROM [dbo].[Central_PasswordPolicyAttribute] WHERE Id= @Id
END

GO

