
--exec Central_User_T_ResetPasswordSave @Id=57,@Password=N'456',@NewPassword=N'456',@ConfirmNewPassword=N'456'
CREATE PROCEDURE [dbo].[Central_User_T_ResetPasswordSave] 
	@Id						INT,
	@Password				VARCHAR(200),
	@NewPassword			VARCHAR(200),
	@ConfirmNewPassword		VARCHAR(200)
AS
BEGIN TRY
BEGIN TRANSACTION
	
	SET NOCOUNT ON;

	DECLARE @Username VARCHAR(50)
	DECLARE @PasswordPolicyId INT
	DECLARE @PasswordComplexity VARCHAR(max)
	DECLARE @TerminationPeriod			INT
	DECLARE @TerminationNotifyPeriod	INT


	SET @PasswordPolicyId = (SELECT PasswordPolicyId FROM Central_Users WHERE Id = @Id)
	SET @Username = (SELECT UserName FROM Central_Users WHERE Id = @Id);
	SET @Password = (SELECT dbo.GetEncryption(@Password, @Username));
	SET @PasswordComplexity = (SELECT dbo.GetPasswordComplexity( @PasswordPolicyId,@NewPassword))
	--SET @NewPassword = (SELECT dbo.GetEncryption(@NewPassword, @Username))
	
	SELECT  @TerminationPeriod = B.Value FROM 
	Central_PasswordAttirbutes A
	INNER JOIN Central_PasswordPolicyWiseSettings AS B ON A.Id = B.PasswordAttributeId
	WHERE B.PasswordPolicyId = @PasswordPolicyId AND A.Id =7

	SELECT  @TerminationNotifyPeriod = B.Value FROM 
	Central_PasswordAttirbutes A
	INNER JOIN Central_PasswordPolicyWiseSettings AS B ON A.Id = B.PasswordAttributeId
	WHERE B.PasswordPolicyId = @PasswordPolicyId AND A.Id = 8


	IF NOT EXISTS (SELECT 1 FROM Central_Users WHERE Id = @Id AND [Password] = @Password)
	BEGIN
		RAISERROR('Your Current Password is Wrong with this user, Please try again!', 16, 1);
	END
	
	IF(ISNULL(LEN(@PasswordComplexity),0)>1)
	BEGIN
		RAISERROR(@PasswordComplexity, 16, 1);
	END

	IF(ISNULL(LEN(@PasswordComplexity),0)=1)
	BEGIN
		SET @NewPassword = (SELECT dbo.GetEncryption(@NewPassword, @Username))
			
		UPDATE	[dbo].[Central_Users]
		SET		[IsPasswordResetRequested] = 0,
				[Password] = @NewPassword,
				NextPasswordTerminationReminderOn = DATEADD(D,@TerminationNotifyPeriod, NextPasswordTerminationReminderOn),
				TerminationDate = DATEADD(D,@TerminationPeriod, TerminationDate)
		WHERE	Id = @Id
				
		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Users', @Id,'CA','CPWC','I', @Id, @Username, 'Password Changed'
		-- End of Audit trail ---------------------
	END
	
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
			SELECT @Id,GETDATE(),@TerminationDate,'Self Password Reset.'
	END

DROP TABLE #TempPasswordAttributes

COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION

	DECLARE @Error NVARCHAR(MAX)
	SELECT @Error = ERROR_MESSAGE()

	INSERT INTO GEN_ErrTable (ErrorNumber,ErrorSeverity,ErrorState,ErrorProcedure,ErrorLine,ErrorMessage)
        VALUES (ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_STATE(),ERROR_PROCEDURE(),ERROR_LINE(),ERROR_MESSAGE())

	RAISERROR(@Error,16,1)

END CATCH

GO

