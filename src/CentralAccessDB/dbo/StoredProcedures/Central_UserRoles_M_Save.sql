CREATE PROCEDURE [dbo].[Central_UserRoles_M_Save]
	@Id	int,
	@GroupId	int = -1,
	@Name	varchar(100),
	@PasswordPolicyId	int = -1,
	@IsActive	bit = NULL,
	@UserId INT = -1,
	@HierarchicalLevel INT=0
AS
BEGIN TRY
BEGIN TRANSACTION 

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	IF(@Name='NULL' OR @Name='')
		BEGIN
			RAISERROR('Enter a role.',16,1)
		END

	IF @Id = 0
	BEGIN
		IF EXISTS(SELECT [Name] FROM [dbo].[Central_UserRoles] WHERE [Name]=@Name)
			BEGIN
				RAISERROR('Cannot create role. role name already exists.',16,1)
			END

		INSERT INTO Central_UserRoles
		(GroupId ,[Name] ,PasswordPolicyId ,IsActive ,CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate,HierarchicalLevel) 
		VALUES
		(@GroupId ,@Name ,@PasswordPolicyId ,@IsActive ,@UserId ,@UserId ,GETDATE() ,GETDATE(),@HierarchicalLevel)

		SET @Id = SCOPE_IDENTITY()
		SELECT @Id AS Id

		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_UserRoles',@Id,'CA','URC','I',@UserId,@Id, @Name
		-- End of Audit trail ---------------------
	END
	ELSE
	BEGIN
		UPDATE Central_UserRoles
		SET
		GroupId=@GroupId,
		Name=@Name,
		PasswordPolicyId=@PasswordPolicyId,
		IsActive=@IsActive,
		CreatedUserId=@UserId,
		ModifiedUserId=@UserId,
		CreatedDate=GETDATE(),
		ModifiedDate=GETDATE(),
		HierarchicalLevel = @HierarchicalLevel
		WHERE Id=@Id

		SELECT @Id AS Id
		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_UserRoles', @Id, 'CA', 'URU', 'U', @UserId, @Id, @Name
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

GO

