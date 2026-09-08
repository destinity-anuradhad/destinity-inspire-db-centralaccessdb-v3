
CREATE PROCEDURE [dbo].[Central_Users_M_Delete]
	@Id		INT,
	@UserId INT = 0
AS
BEGIN TRY
BEGIN TRANSACTION

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	IF EXISTS(SELECT 1 FROM [HotelResWeb_AuditTail]..[AuditTrailMaster] WITH(NOLOCK) WHERE [UserID]=@Id)
	BEGIN
		RAISERROR('Unable to delete user. This user has associated transaction records.',16,1)
	END
	ELSE
	BEGIN
		DECLARE @UserName VARCHAR(100)
	
		SELECT	@UserName = FullName
		FROM	Central_Users
		WHERE	Id = @Id

		INSERT INTO [dbo].[Central_Users_DeletedUserLog]
		([CentralUserId],[GroupId],[UserName],[Password],[FullName],[EmpNumber],[Email],[MobileNumber],[DesignationId],[DepartmentId],[AuhenticatedMethordId]
		,[IsLoked],[IsPermanentlyLocked],[IsPasswordResetRequested],[LastLoginDate],[TerminationDate],[NextPasswordTerminationReminderOn],[LeagalIdnumber]
		,[IsActive],[CreatedUserId],[ModifiedUserId],[CreatedDate],[ModifiedDate],[PasswordPolicyId],[LoginAttempts],[UniqueId])
		SELECT 
		 [Id],[GroupId],[UserName],[Password],[FullName],[EmpNumber],[Email],[MobileNumber],[DesignationId],[DepartmentId],[AuhenticatedMethordId]
		,[IsLoked],[IsPermanentlyLocked],[IsPasswordResetRequested],[LastLoginDate],[TerminationDate],[NextPasswordTerminationReminderOn],[LeagalIdnumber]
		,[IsActive],[CreatedUserId],[ModifiedUserId],[CreatedDate],[ModifiedDate],[PasswordPolicyId],[LoginAttempts],[UniqueId]
		FROM	Central_Users
		WHERE	Id = @Id

		DELETE 
		FROM [dbo].[Central_UserWiseIndividualMenuItems]
		WHERE UserId = @Id

		DELETE 
		FROM [dbo].[Central_UserWiseModules]
		WHERE UserId = @Id

		DELETE 
		FROM [dbo].[Central_UserWiseProperties]
		WHERE UserId = @Id
	
		DELETE 
		FROM [dbo].[Central_UserWiseUserRoles]
		WHERE UserId = @Id

		DELETE FROM Central_Users WHERE Id=@Id

		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Users',@Id,'CA','UD','D',@UserId,@Id, @UserName
		--End of Audit trail ---------------------

		DECLARE @PropertyId INT = 0
		DECLARE @IsActive BIT = 0

		EXEC Categlog_vrV2..[POSBackend_M_User] @UserId = @Id,@Username = @UserName,@IsActive = @IsActive, @CreatedOrEditedUserId = @UserId, @Operation = 'D',@PropertyId = @PropertyId 
	END

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

