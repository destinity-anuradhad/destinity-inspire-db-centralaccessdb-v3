CREATE PROCEDURE [dbo].[Central_UserRoles_M_Delete]
	@Id		INT,
	@UserId	INT = 0
AS
BEGIN TRY
BEGIN TRANSACTION

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DECLARE @Name VARCHAR(100)
	
	SELECT	@Name = [Name]
	FROM	Central_UserRoles
	WHERE	Id = @Id

	DELETE 
	FROM [dbo].[Central_UserRoleWiseMenuItems]
	WHERE UserRoleId = @Id

	DELETE 
	FROM [dbo].[Central_UserRoleWiseProperties]
	WHERE UserRoleId = @Id

	DELETE FROM Central_UserRoles WHERE Id = @Id

	-- Audit trail ----------------------------
	EXEC HotelResWeb_AuditTail_WriteToLog 'Central_UserRoles',@Id,'CA','URD','D',@UserId,@Id, @Name
	-- End of Audit trail ---------------------

COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	
	DECLARE  @ERRmsg VARCHAR(MAX) =ERROR_MESSAGE()
	INSERT INTO GEN_ErrTable (ErrorNumber,ErrorSeverity,ErrorState,ErrorProcedure,ErrorLine,ErrorMessage)
    VALUES (ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_STATE(),ERROR_PROCEDURE(),ERROR_LINE(),@ERRmsg)		
	RAISERROR(@ERRmsg,16,1)

END CATCH

GO

