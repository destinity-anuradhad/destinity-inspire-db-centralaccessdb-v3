
CREATE PROCEDURE [dbo].[Central_UserWiseModules_M_Save]
	@UserId	int,
	--@PropertyId	int,
	@UserWiseModulesJson  NVARCHAR(max),
	@ApplicablePropertiesJson NVARCHAR(max)
AS
BEGIN TRY
BEGIN TRANSACTION 

--Stehani
-- @Nov  9 2020  3:22PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DECLARE @AssignedPropertyId INT

			SELECT  UserId ,
					--@PropertyId AS 'PropertyId',
					--(Select [PropertyId] FROM [dbo].[Central_UserWiseProperties] WHERE UserId=UserId) AS 'PropertyId',
					ModuleId ,
					(SELECT [dbo].[GetEncryption] (ModuleId, UserId)) AS 'EncryptedModuleId',
					@UserId AS 'CreatedUserId',
					@UserId AS 'ModifiedUserId',
					GETDATE() AS 'CreatedDate',
					GETDATE() AS 'ModifiedDate'
			INTO #tempUserWiseModules
			FROM 
				OPENJSON (@UserWiseModulesJson)
		    WITH (
			   ModuleId INT '$.ModuleId',
			   UserId INT '$.UserId'
		    )

			--SELECT * from #tempUserWiseModules

		SELECT  
				PropertyId
		INTO	#tempUserWiseProperties
		FROM	OPENJSON (@ApplicablePropertiesJson)
		WITH	(
					PropertyId INT '$.PropertyId'
				)

		DELETE FROM Central_UserWiseModules 
			WHERE [UserId] IN (SELECT UserId FROM #tempUserWiseModules) 
			AND [PropertyId] IN (SELECT PropertyId FROM #tempUserWiseProperties)

		WHILE EXISTS (SELECT * FROM #tempUserWiseProperties)
		BEGIN
			SELECT TOP 1 
			@AssignedPropertyId=PropertyId			
			FROM #tempUserWiseProperties	

			INSERT INTO Central_UserWiseModules
				(UserId ,PropertyId ,ModuleId, EncryptedModuleId ,CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate) 
			SELECT UserId,@AssignedPropertyId,ModuleId,EncryptedModuleId,@UserId,@UserId,CreatedDate,ModifiedDate
			FROM #tempUserWiseModules

			DELETE TOP (1) FROM #tempUserWiseProperties
		END

		DROP TABLE #tempUserWiseProperties
		DROP TABLE #tempUserWiseModules		

COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	
	DECLARE  @ERRmsg VARCHAR(MAX) =ERROR_MESSAGE()
	INSERT INTO GEN_ErrTable (ErrorNumber,ErrorSeverity,ErrorState,ErrorProcedure,ErrorLine,ErrorMessage)
    VALUES (ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_STATE(),ERROR_PROCEDURE(),ERROR_LINE(),@ERRmsg)		
	RAISERROR(@ERRmsg,16,1)

END CATCH

--Select [PropertyId] FROM [dbo].[Central_UserWiseProperties] WHERE UserId=1

GO

