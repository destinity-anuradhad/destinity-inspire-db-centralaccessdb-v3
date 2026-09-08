
-- =============================================
-- Author		:	Ayomi Gunasekara
-- Create date	:	2020-11-23
-- Description	:	Central Passowrd Attribute DELETE
-- =============================================
CREATE PROCEDURE [dbo].[Central_PasswordAttirbutes_M_Delete]
	@Id		INT,
	@UserId	INT = 0
AS
BEGIN
	
	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DELETE FROM Central_PasswordPolicy WHERE Id = @Id

	-- Audit trail ----------------------------
	EXEC HotelResWeb_AuditTail_WriteToLog 'Central_PasswordPolicy',@Id,'CA','PPHD','D',@UserId,@Id
	-- End of Audit trail ---------------------
   
END

GO

