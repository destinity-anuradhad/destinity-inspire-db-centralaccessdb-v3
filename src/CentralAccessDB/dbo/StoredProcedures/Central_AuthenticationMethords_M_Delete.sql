CREATE PROCEDURE [dbo].[Central_AuthenticationMethords_M_Delete]
	@Id	INT,
    @UserId INT=-1
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:35PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DELETE FROM Central_AuthenticationMethords WHERE Id=@Id

	-- Audit trail ----------------------------
	EXEC HotelResWeb_AuditTail_WriteToLog 'Central_AuthenticationMethords',@Id,'CA','AMCD','D',@UserId,@Id, @Id
	-- End of Audit trail ---------------------
END

GO

