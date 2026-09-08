CREATE PROCEDURE [dbo].[Central_Designations_M_Delete]
	@Id	INT,
	@UserId INT =-1
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:44PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DELETE FROM Central_Designations WHERE Id=@Id

	-- Audit trail ----------------------------
	EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Designations',@Id,'CA','DesCD','D',@UserId,@Id, @Id
	-- End of Audit trail ---------------------
END

GO

