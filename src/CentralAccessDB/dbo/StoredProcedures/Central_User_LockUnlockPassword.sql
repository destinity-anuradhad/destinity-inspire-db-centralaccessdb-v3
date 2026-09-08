
CREATE PROCEDURE [dbo].[Central_User_LockUnlockPassword] 
	@Id					INT,
	@LockUnlockReasonId	INT,
	@Remark				VARCHAR(MAX),
	@UserId				INT
AS
BEGIN TRY
BEGIN TRANSACTION 

	INSERT INTO [dbo].[Central_UserLockUnlockLog]( [UserId], [LockUnlockReasonId], [Remark], [TxnDateTime], [TxnUserId])
	VALUES(@Id, @LockUnlockReasonId, @Remark, GETDATE(), @UserId)

	DECLARE @ReasonType		VARCHAR(5),
			@ReasonName		VARCHAR(50),
			@FullName		VARCHAR(200),
			@ProcessType	VARCHAR(10),
			@Username		VARCHAR(200)
	
	SELECT	@ReasonType = Process, @ReasonName = Name 
	FROM	[dbo].[Central_UserLockUnlockReasons]
	WHERE	Id = @LockUnlockReasonId
	SELECT @ReasonType AS 'ReasonType'
	SELECT @FullName = FullName,@Username=Username FROM Central_Users WHERE Id = @Id

	DECLARE @PropertyId INT = 0
	DECLARE @IsActive BIT = 0

	IF(@ReasonType = 'TL')
	BEGIN
		SET @ProcessType = 'UTL'

		UPDATE	Central_Users
		SET		[IsLoked] = 1 
		WHERE	Id = @Id

		SET @IsActive=0
		EXEC Categlog_vrV2..[POSBackend_M_User] @UserId = @Id,@Username = @UserName,@IsActive = @IsActive, @CreatedOrEditedUserId = @UserId, @Operation = 'U',@PropertyId = @PropertyId 
	END
	ELSE IF(@ReasonType = 'PL')
	BEGIN
		SET @ProcessType = 'UPL'

		UPDATE	Central_Users
		SET		[IsPermanentlyLocked] = 1 
		WHERE	Id = @Id

		SET @IsActive=0
		EXEC Categlog_vrV2..[POSBackend_M_User] @UserId = @Id,@Username = @UserName,@IsActive = @IsActive, @CreatedOrEditedUserId = @UserId, @Operation = 'U',@PropertyId = @PropertyId 
	END
	ELSE IF(@ReasonType = 'UL')
	BEGIN
		SET @ProcessType = 'UPTU'

		UPDATE	Central_Users
		SET		[IsPermanentlyLocked] = 0,
				[IsLoked] = 0,
				[LoginAttempts] = 0
 		WHERE	Id = @Id

		SET @IsActive=1
		EXEC Categlog_vrV2..[POSBackend_M_User] @UserId = @Id,@Username = @UserName,@IsActive = @IsActive, @CreatedOrEditedUserId = @UserId, @Operation = 'U',@PropertyId = @PropertyId 
	END	

	-- Audit trail ----------------------------
	EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Users',@Id,'CA',@ProcessType,'U',@UserId,@FullName, @ReasonName
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

