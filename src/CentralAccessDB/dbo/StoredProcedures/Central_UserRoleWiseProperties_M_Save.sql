CREATE PROCEDURE [dbo].[Central_UserRoleWiseProperties_M_Save]
	--@UserRoleId	int,
	@UserRoleWisePropertiesJson  NVARCHAR(max),
	@UserId INT = -1

AS
BEGIN TRY
BEGIN TRANSACTION

--Stehani
-- @Nov  9 2020 10:58AM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	
		--INSERT INTO Central_UserRoleWiseProperties
		--(UserRoleId ,PropertyId ,CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate) 
		SELECT	UserRoleId ,
				PropertyId ,
				(SELECT [dbo].[GetEncryption] (PropertyId, UserRoleId)) AS 'EncryptedPropertyId',
				@UserId AS'CreatedUserId',
				@UserId AS 'ModifiedUserId',
				GETDATE() AS 'CreatedDate',
				GETDATE() AS 'ModifiedDate'
				INTO #tempUserRoleWiseProperties
			FROM 
				OPENJSON (@UserRoleWisePropertiesJson)
		    WITH (
			   PropertyId INT '$.PropertyId',
			   UserRoleId INT '$.UserRoleId'
		    )

		DELETE FROM Central_UserRoleWiseProperties WHERE [UserRoleId] IN (SELECT UserRoleId FROM #tempUserRoleWiseProperties)

		INSERT INTO Central_UserRoleWiseProperties
		(UserRoleId ,PropertyId, EncryptedPropertyId ,CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate) 
		SELECT * FROM #tempUserRoleWiseProperties

		DROP TABLE #tempUserRoleWiseProperties

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

