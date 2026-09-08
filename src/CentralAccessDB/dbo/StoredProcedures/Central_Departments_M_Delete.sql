CREATE PROCEDURE [dbo].[Central_Departments_M_Delete]
	@Id	INT,
	@UserId INT
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:40PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DELETE FROM Central_Departments WHERE Id=@Id
	-- Audit trail ----------------------------
	EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Departments',@Id,'CA','DepCD','D',@UserId,@Id, @Id
	-- End of Audit trail ---------------------
END

GO

