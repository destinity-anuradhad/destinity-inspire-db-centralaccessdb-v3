
CREATE PROCEDURE [dbo].[Central_Users_M_Save]
	@Id							INT,
	@GroupId					INT = -1,
	@UserId						INT = -1,
	@UserName					VARCHAR(200) = NULL,
	@Password					VARCHAR(MAX) = NULL,
	@FullName					VARCHAR(100) = NULL,
	@EmpNumber					VARCHAR(50) = NULL,
	@Email						VARCHAR(100) = NULL,
	@MobileNumber				VARCHAR(50) = NULL,
	@DesignationId				INT,
	@DepartmentId				INT,
	@AuhenticatedMethordId		INT,
	@LeagalIdnumber				VARCHAR(100) = NULL,
	@IsActive					BIT = NULL,
	@PasswordPolicyId			INT,
	@PropertyId					INT=0,
	@Remark						NVARCHAR(1000)=NULL
AS
BEGIN TRY
BEGIN TRANSACTION 

--Stehani
-- @Nov  9 2020  1:08PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DECLARE @CreatedDate	datetime
	DECLARE @IsPasswordResetRequested BIT
	DECLARE @PasswordAttributeId INT

	INSERT INTO [dbo].[ParamUserSave]
           ([Id],[GroupId],[UserId],[UserName],[Password],[FullName],[EmpNumber],[Email],[MobileNumber],[DesignationId],[DepartmentId],
		   [AuhenticatedMethordId],[LeagalIdnumber],[IsActive],[PasswordPolicyId],[PropertyId])
	SELECT 	@Id,@GroupId,@UserId,@UserName,@Password,@FullName,@EmpNumber,@Email,@MobileNumber,@DesignationId,@DepartmentId,			
	@AuhenticatedMethordId,@LeagalIdnumber,@IsActive,@PasswordPolicyId,@PropertyId	

	IF(@DesignationId=0)
		BEGIN
			RAISERROR('Select a designation.',16,1)
		END

	IF(@DepartmentId=0)
		BEGIN
			RAISERROR('Select a department.',16,1)
		END

	IF(@AuhenticatedMethordId=0)
		BEGIN
			RAISERROR('Select a auhentication methord.',16,1)
		END

	IF(@PasswordPolicyId=0)
		BEGIN
			RAISERROR('Select a password policy.',16,1)
		END

	SET @PasswordAttributeId = (SELECT DISTINCT ISNULL(B.Id,0) FROM Central_PasswordPolicyWiseSettings A INNER JOIN [dbo].[Central_PasswordAttirbutes] B ON B.Id=A.PasswordAttributeId WHERE A.[PasswordPolicyId]= @PasswordPolicyId AND B.Id=10)
	
	IF(@PasswordAttributeId>1 OR @PasswordAttributeId <> '')
		BEGIN
			SET @IsPasswordResetRequested = 1
		END
	ELSE
		BEGIN
			SET @IsPasswordResetRequested = 0
		END

	
	SET @CreatedDate = (SELECT CreatedDate FROM Central_Users WHERE Id = @Id)

	DECLARE @PreviousIsActive BIT

	IF EXISTS(SELECT 1 FROM Central_Users WITH(NOLOCK) WHERE Id = @Id)
	BEGIN
		
		SELECT @PreviousIsActive = IsActive FROM Central_Users WITH(NOLOCK) WHERE Id=@Id
	END

	IF @Id = 0
	BEGIN
		
		DECLARE @TerminationDateValue	INT,
				@NextReminderDate		INT
				DECLARE @TerminationDate Date

		IF EXISTS(SELECT [UserName] FROM [dbo].[Central_Users] WHERE [UserName]=@UserName)
			BEGIN
				RAISERROR('Cannot create user. Username already exists.',16,1)
			END

		IF EXISTS(SELECT [EmpNumber] FROM [dbo].[Central_Users] WHERE [EmpNumber]=@EmpNumber)
			BEGIN
				RAISERROR('Employee number already exists.',16,1)
			END

		SELECT	@TerminationDateValue = ISNULL([Value], 120)
		FROM	Central_PasswordPolicyWiseSettings
		WHERE   PasswordPolicyId = @PasswordPolicyId AND PasswordAttributeId = 7

		SELECT	@NextReminderDate = ISNULL([Value], 106)
		FROM	Central_PasswordPolicyWiseSettings
		WHERE	PasswordPolicyId = @PasswordPolicyId AND PasswordAttributeId = 8

		SET @TerminationDate = DATEADD(D, @TerminationDateValue, GETDATE())
		

		INSERT INTO Central_Users (GroupId ,UserName ,Password ,FullName ,EmpNumber ,Email ,MobileNumber ,DesignationId ,DepartmentId ,AuhenticatedMethordId ,
					[IsPasswordResetRequested],LastLoginDate ,TerminationDate , NextPasswordTerminationReminderOn, LeagalIdnumber ,IsActive ,CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate, PasswordPolicyId,UniqueId,CentralRemark) 
		VALUES		(@GroupId ,@UserName , (SELECT DBO.GetEncryption(@Password , @UserName)),@FullName ,@EmpNumber ,@Email ,@MobileNumber ,@DesignationId ,@DepartmentId ,@AuhenticatedMethordId ,@IsPasswordResetRequested,
					GETDATE() , @TerminationDate, DATEADD(D, @NextReminderDate, GETDATE()) ,@LeagalIdnumber ,@IsActive ,@UserId ,@UserId ,GETDATE() ,GETDATE(), @PasswordPolicyId,NEWID(),@Remark)

		SET @Id = SCOPE_IDENTITY()
		------------------stehani---------------------------
		SELECT PasswordAttributeId
		INTO #TempPasswordAttributes
		FROM Central_PasswordPolicyWiseSettings
		WHERE PasswordPolicyId=@PasswordPolicyId

		IF EXISTS (SELECT * FROM #TempPasswordAttributes WHERE PasswordAttributeId=7)
		BEGIN
			INSERT INTO [dbo].[Central_UserPasswordResetExpiredDetails]
           ([UserId],[PasswordReset],[PasswordExpired],[Remark])
			SELECT @Id,GETDATE(),@TerminationDate,'First Time'
		END

		DROP TABLE #TempPasswordAttributes
		--------------------------------------------------------
		SELECT @Id AS Id

		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Users',@Id,'CA','UC','I',@UserId,@FullName
		-- End of Audit trail ---------------------

		EXEC Categlog_vrV2..[POSBackend_M_User] @UserId = @Id,@Username = @UserName,@IsActive = @IsActive, @CreatedOrEditedUserId = @UserId, @Operation = 'I',@PropertyId = @PropertyId 


	END
	ELSE
	BEGIN

	--IF EXISTS( SELECT [UserName] FROM [dbo].[Central_Users] WHERE Id<>@Id)
	--	BEGIN
	--		RAISERROR('Cannot create user. Username already exists.',16,1)
	--	END

	    IF EXISTS( SELECT [EmpNumber] FROM [dbo].[Central_Users] WHERE Id<>@Id AND [EmpNumber]=@EmpNumber)
		BEGIN
			RAISERROR('Employee number already exists.',16,1)
		END

		UPDATE Central_Users
		SET
			GroupId					=	@GroupId,
			UserName				=	@UserName,
			--Password				=	(SELECT DBO.GetEncryption(@Password , @UserName)),
			FullName				=	@FullName,
			EmpNumber				=	@EmpNumber,
			Email					=	@Email,
			MobileNumber			=	@MobileNumber,
			DesignationId			=	@DesignationId,
			DepartmentId			=	@DepartmentId,
			AuhenticatedMethordId	=	@AuhenticatedMethordId,
			LastLoginDate			=	GETDATE(),
			LeagalIdnumber			=	@LeagalIdnumber,
			IsActive				=	@IsActive,
			--CreatedUserId			=	@UserId,
			ModifiedUserId			=	@UserId,
			CreatedDate				=	@CreatedDate,
			ModifiedDate			=	GETDATE(),
			[PasswordPolicyId]		=	@PasswordPolicyId,
			CentralRemark					= @Remark
		WHERE Id = @Id

		IF(@IsActive <> @PreviousIsActive)
		BEGIN
			INSERT INTO Central_User_Activation_Log
			([IsActivePreviousState], [ModifiedUserId], [ModifiedDateTime],[PropertyId],UserId,IsActive)
			SELECT @PreviousIsActive,@UserId,GETDATE(),@PropertyId,@Id,@IsActive

			EXEC Categlog_vrV2..[POSBackend_M_User] @UserId = @Id,@Username = @UserName,@IsActive = @IsActive, @CreatedOrEditedUserId = @UserId, @Operation = 'U',@PropertyId = @PropertyId 
		END

		SELECT @Id AS Id
		
		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Users', @Id, 'CA', 'UU', 'U', @UserId, @FullName
		-- End of Audit trail ---------------------
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

		--EXEC Central_Users_M_Save 
		--@Id = NULL,
		--@GroupId = 1,
		--@UserId = 1,
		--@UserName = 'test',
		--@Password = 'test',
		--@FullName = 'test',
		--@EmpNumber = '001',
		--@Email = 'test',
		--@MobileNumber = '0445889662',
		--@DesignationId = 1,
		--@DepartmentId = 1,
		--@AuhenticatedMethordId = 1,
		--@IsLoked = 1,
		--@LeagalIdnumber = '123664',
		--@IsActive = 1

GO

