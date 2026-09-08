
CREATE PROCEDURE [dbo].[Central_UserWiseUserRoles_M_Save]
	@UserId	int,
	@GroupId int = -1,
	@UserWiseUserRolesJson  NVARCHAR(max)

AS
BEGIN TRY
BEGIN TRANSACTION 

--Stehani
-- @Nov  9 2020  4:12PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

		Select	UserId ,
				UserRoleId ,
				(SELECT [dbo].[GetEncryption] (UserRoleId, UserId)) AS 'EncryptedUserRoleId',
				@GroupId AS 'GroupId',
				IsMainRole ,
				@UserId AS 'CreatedUserId',
				@UserId AS 'ModifiedUserId',
				GETDATE() AS 'CreatedDate',
				GETDATE() AS 'ModifiedDate'
			INTO #tempUserWiseUserRoles
			FROM 
				OPENJSON (@UserWiseUserRolesJson)
		    WITH (
			   UserRoleId INT '$.UserRoleId',
			   UserId INT '$.UserId',
			   IsMainRole BIT '$.IsMainRole'
		    )

		DECLARE @Uuid NVARCHAR(2000) = NEWID()

		INSERT INTO [dbo].[Central_UserWiseUserRoles_Log]
           ([UserId],[UserRoleId],[EncryptedUserRoleId],[GroupId],[IsMainRole],[CreatedUserId],[ModifiedUserId]
           ,[CreatedDate],[ModifiedDate],[Uuid])
		SELECT 
			[UserId],[UserRoleId],[EncryptedUserRoleId],[GroupId],[IsMainRole],[CreatedUserId],[ModifiedUserId]
           ,[CreatedDate],[ModifiedDate],@Uuid
		FROM Central_UserWiseUserRoles 
		WHERE [UserId] IN (SELECT UserId FROM #tempUserWiseUserRoles)

		DELETE FROM Central_UserWiseUserRoles 
		WHERE [UserId] IN (SELECT UserId FROM #tempUserWiseUserRoles)

		INSERT INTO Central_UserWiseUserRoles
		(UserId ,UserRoleId ,EncryptedUserRoleId ,GroupId, IsMainRole ,CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate) 
		SELECT * FROM #tempUserWiseUserRoles

		DROP TABLE #tempUserWiseUserRoles		

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

