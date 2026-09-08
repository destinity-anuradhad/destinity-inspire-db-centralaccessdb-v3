
--Central_User_T_ResetUserSave 2, 1 , 'Test', 1
CREATE PROCEDURE [dbo].[Central_User_T_ResetUserSave] 
	@Id						INT, 
	@PasswordResetReasonId	INT,
	@Remark					VARCHAR(MAX),
	@UserId					INT,
	@IsLoked BIT
AS
BEGIN TRY
BEGIN TRANSACTION 

	DECLARE @TemporaryPassword TABLE
	(
		Id					INT, 
		PasswordPolicyId	INT,
		NewResetPassword	VARCHAR(MAX)
	)

	DECLARE @TempPassword	VARCHAR(MAX),
			@Name		VARCHAR(100)
	DECLARE @PasswordPolicyId INT
	
	SELECT @Name = [FullName] FROM [Central_Users] WHERE Id = @Id
	SELECT @PasswordPolicyId= PasswordpolicyId FROM [Central_Users] WHERE Id = @Id

	INSERT INTO [dbo].[Central_PasswordResetRequestLog] ([UserId], [PasswordResetRequestReasonId], [Remark], [TxnDateTime], [TxnUserId])
	VALUES (@Id, @PasswordResetReasonId, @Remark, GETDATE(), @UserId)

	DECLARE @TerminationDateValue INT
	DECLARE @TerminationDate Date

	SELECT PasswordAttributeId
	INTO #TempPasswordAttributes
	FROM Central_PasswordPolicyWiseSettings
	WHERE PasswordPolicyId=@PasswordPolicyId

	IF EXISTS (SELECT * FROM #TempPasswordAttributes WHERE PasswordAttributeId=7)
	BEGIN
			SELECT	@TerminationDateValue = ISNULL([Value], 120)
			FROM	Central_PasswordPolicyWiseSettings
			WHERE   PasswordPolicyId = @PasswordPolicyId AND PasswordAttributeId = 7

			SET @TerminationDate = DATEADD(D, @TerminationDateValue, GETDATE())
			INSERT INTO [dbo].[Central_UserPasswordResetExpiredDetails]
			   ([UserId],[PasswordReset],[PasswordExpired],[Remark])
			SELECT @Id,GETDATE(),@TerminationDate,@Remark
	END

	DROP TABLE #TempPasswordAttributes
	
	INSERT INTO @TemporaryPassword(Id, PasswordPolicyId, NewResetPassword)
	EXEC Central_Modules_T_GetDefaultPassword_ByUserId @Id

	SELECT TOP 1 @TempPassword = NewResetPassword FROM @TemporaryPassword

	UPDATE	[dbo].[Central_Users]
	SET		[IsPasswordResetRequested] = 1,
			[TerminationDate]=NULL,
			[Password] = (SELECT dbo.GetEncryption(@TempPassword, UserName)),
			IsLoked=@IsLoked
	WHERE	Id = @Id

	SELECT @Id AS Id, @TempPassword AS Password

	-- Audit trail ----------------------------
	EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Users',@Id,'CA','UPU','U',@UserId,@Name, 'Password changed'
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

