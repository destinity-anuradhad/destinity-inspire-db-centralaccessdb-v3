
---EXEC Central_User_T_UserLoginSelect @Username='asd',@Password='123'
-- =============================================
-- Author		:	Ayomi Gunasekara
-- Create date	:	2020-11-11
-- Description	:	User Select
-- =============================================
---exec Central_User_T_UserLoginSelect 'thiruni',123,'123','123'
CREATE PROCEDURE [dbo].[Central_User_T_UserLoginSelect]
	@Username as NVARCHAR(50),
	@Password as NVARCHAR(50),
	@IpAddress NVARCHAR(50)='',
	@Browser NVARCHAR(80)=''
AS
--BEGIN TRY
--BEGIN TRANSACTION 
	SET NOCOUNT ON;

	DECLARE @UserId						INT
	DECLARE @Id							INT
	DECLARE @MaxLoginAttempts			INT
	DECLARE @PasswordPolicyId			INT
	DECLARE @LoginAttempts				INT
	DECLARE @NewLoginAttempts			INT
	DECLARE @IsActive					BIT
	DECLARE @IsLoked					BIT
	DECLARE @IsPermanentlyLocked		BIT
	DECLARE @Code						INT
	DECLARE @Remark						VARCHAR(MAX)
	DECLARE @TerminationDate			DATE
	DECLARE @AttemptStatus				CHAR(1) = 'F'
	DECLARE @NextPasswordTerminationReminderOn	DATE

	--IF NOT EXISTS(SELECT 1 FROM Central_Users WHERE UserName = @Username)
	--	BEGIN

	--		SET @Remark = 'No user found with entered username.'
	--		RAISERROR(@Remark,16,1)	
	--	END

	SELECT 
		@Id = Id,
		@UserId = Id,
		@PasswordPolicyId = PasswordPolicyId,
		@LoginAttempts = LoginAttempts,
		@TerminationDate = TerminationDate,
		@NextPasswordTerminationReminderOn = NextPasswordTerminationReminderOn
	FROM [dbo].[Central_Users] with(nolock)
	WHERE Username = @Username

	IF @LoginAttempts = -1
	BEGIN
		SET @LoginAttempts = 0
	END

	Print @TerminationDate

	SELECT @MaxLoginAttempts = [Value] 
	FROM Central_PasswordPolicyWiseSettings  with(nolock)
	WHERE PasswordPolicyId = @PasswordPolicyId
	AND PasswordAttributeId = 9 -- Max Unsucsessfull Password Attepts in password policy
	
	SET @NewLoginAttempts = (@LoginAttempts) 
	
	IF NOT EXISTS (SELECT 1 FROM Central_Users with(nolock) WHERE UserName = @Username)
	BEGIN		
		SET @Remark = 'ERR-No user found with entered username.'
		RAISERROR(@Remark,16,1)	
		SET @UserId=0
	END
	ELSE IF NOT EXISTS(SELECT 1 FROM Central_Users with(nolock) WHERE UserName = @Username AND Password = (SELECT DBO.GetEncryption(@Password, @Username)))
	BEGIN
		IF (@NewLoginAttempts >= @MaxLoginAttempts)
		BEGIN
			SET @Remark = 'ERR-User locked. Maximum number of attempts exceeded.'
			RAISERROR(@Remark,16,1)
			EXEC [dbo].[Central_User_LockUnlockPassword] @Id = @UserId, @LockUnlockReasonId = 6, @Remark = @Remark ,@UserId = @UserId

		END
		ELSE
		BEGIN
			UPDATE	Central_Users
			SET		LoginAttempts = @NewLoginAttempts +1 --(+1) is for this attempt
			WHERE	Username = @Username

			SET @Remark = 'ERR-Invalid credentials. Please check and try again.'

			RAISERROR(@Remark,16,1)			
		END
			
	END
	--ELSE IF (CONVERT(DATE,@NextPasswordTerminationReminderOn) < CONVERT(DATE,GETDATE()))
	--BEGIN
	--	SET @Remark = 'WAR-Your password is going to expire on ' + CONVERT(varchar(20),@TerminationDate) + '. Please reset your password to avoid termination'
	--	RAISERROR(@Remark,16,1)		
	--END
	ELSE IF (CONVERT(DATE,@TerminationDate) <= CONVERT(DATE,GETDATE()))
	BEGIN
		SET @Remark = 'ERR-Your password has been expired. Please contact administrator.'
		RAISERROR(@Remark,16,1)		
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM Central_Users with(nolock) WHERE  UserName = @Username AND IsActive = 0 )
		BEGIN
			SET @Remark = 'ERR-Sorry your account has been deactivated. Please contact administrator.'
			RAISERROR(@Remark,16,1)		
		END
		ELSE IF EXISTS (SELECT 1 FROM Central_Users with(nolock) WHERE UserName = @Username AND (IsLoked = 1 OR IsPermanentlyLocked = 1))
		BEGIN 
			SET @Remark = 'ERR-Sorry your account has been locked. Please contact administrator.'
			RAISERROR(@Remark,16,1)
		END
		ELSE 
		BEGIN
		
			SET  @AttemptStatus	 = 'S'

			UPDATE	Central_Users
			SET		LoginAttempts = 0,
					LastLoginDate = GETDATE()
			WHERE	UserName = @Username 

			SELECT	* 
			FROM	Central_Users with(nolock)
			WHERE	UserName = @Username 
			AND Password = (DBO.GetEncryption(@Password, @Username))

			SET @Remark = 'Successfull login.'
		END
		
	END

	INSERT INTO [dbo].[Central_UserLoginAttempts]([UserId], [Status],[TxnDateTime],[IPAddress],[BrowserKey])
	VALUES	(@UserId, @AttemptStatus , GETDATE(),@IpAddress,@Browser)

	-- Audit trail ----------------------------
	EXEC HotelResWeb_AuditTail_WriteToLog 'Central_UserLoginAttempts',@UserId,'CA','CNTRLGN','I',@UserId,@Username, @Remark
	-- End of Audit trail ---------------------

	------ UserWiseModuleLogin Table IsActive column update-----
	--		UPDATE	[dbo].[Central_UserWiseModuleLogin]
	--		SET [IsActive] = 0
	--		WHERE [UserId]= @UserId
	------ End --------

--COMMIT TRANSACTION
--END TRY
--BEGIN CATCH
--	--ROLLBACK TRANSACTION

--	DECLARE @Error NVARCHAR(MAX)
--	SELECT @Error = ERROR_MESSAGE()

--	INSERT INTO GEN_ErrTable (ErrorNumber,ErrorSeverity,ErrorState,ErrorProcedure,ErrorLine,ErrorMessage)
--        VALUES (ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_STATE(),ERROR_PROCEDURE(),ERROR_LINE(),ERROR_MESSAGE())

--	RAISERROR(@Error,16,1)

--END CATCH

GO

